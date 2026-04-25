#!/usr/bin/env python3
"""
LLM Deploy Helper — detect your hardware and get the perfect local LLM setup command.

Source: Reddit pain #6 — Local LLM deployment too hard
> "most annoyed I've ever been at myself for not going overboard with RAM" — r/LocalLLaMA (227↑)
> "need a 0.01bit quant of that" — r/LocalLLaMA (185↑)
> "284B A13B is not gonna fit on 128GB, need at least 256GB" — r/LocalLLaMA (87↑)
"""

import subprocess, os, sys, platform, json, shutil
from typing import Optional

# ── Model database ──
# format: name, size_gb, min_ram_gb, tags, ollama_name, recommend_vram_gb
MODELS = [
    # Tiny (can run on anything)
    {"name": "Qwen2.5 0.5B",        "size_gb": 0.5,  "min_ram": 2,   "vram": 0,  "tags": ["chat"], "ollama": "qwen2.5:0.5b", "ctx": 4096},
    {"name": "SmolLM2 1.7B",         "size_gb": 1.0,  "min_ram": 4,   "vram": 0,  "tags": ["chat"], "ollama": "smollm2:1.7b", "ctx": 4096},

    # Small (most laptops)
    {"name": "Gemma 3 4B",           "size_gb": 2.5,  "min_ram": 8,   "vram": 4,  "tags": ["chat", "coding"], "ollama": "gemma3:4b", "ctx": 8192},
    {"name": "Llama 3.2 3B",         "size_gb": 2.0,  "min_ram": 8,   "vram": 4,  "tags": ["chat", "coding"], "ollama": "llama3.2:3b", "ctx": 8192},
    {"name": "Phi-4 Mini",           "size_gb": 2.5,  "min_ram": 8,   "vram": 4,  "tags": ["coding", "reasoning"], "ollama": "phi4:mini", "ctx": 8192},
    {"name": "Qwen2.5 7B",           "size_gb": 4.5,  "min_ram": 8,   "vram": 6,  "tags": ["chat", "coding", "writing"], "ollama": "qwen2.5:7b", "ctx": 8192},

    # Medium (gaming laptops / entry GPUs)
    {"name": "Mistral 7B",           "size_gb": 4.5,  "min_ram": 8,   "vram": 6,  "tags": ["chat", "coding", "writing"], "ollama": "mistral", "ctx": 8192},
    {"name": "Llama 3.1 8B",         "size_gb": 5.0,  "min_ram": 12,  "vram": 8,  "tags": ["chat", "coding", "writing", "reasoning"], "ollama": "llama3.1:8b", "ctx": 8192},
    {"name": "Gemma 3 12B",          "size_gb": 7.0,  "min_ram": 16,  "vram": 10, "tags": ["chat", "coding", "writing"], "ollama": "gemma3:12b", "ctx": 8192},
    {"name": "DeepSeek R1 8B",       "size_gb": 5.0,  "min_ram": 12,  "vram": 8,  "tags": ["reasoning", "coding"], "ollama": "deepseek-r1:8b", "ctx": 8192},

    # Large (workstations)
    {"name": "Qwen2.5 32B",          "size_gb": 19.0, "min_ram": 32,  "vram": 20, "tags": ["coding", "writing", "reasoning"], "ollama": "qwen2.5:32b", "ctx": 8192},
    {"name": "Llama 3.1 70B",        "size_gb": 40.0, "min_ram": 64,  "vram": 40, "tags": ["coding", "writing", "reasoning"], "ollama": "llama3.1:70b", "ctx": 8192},
    {"name": "DeepSeek R1 32B",      "size_gb": 19.0, "min_ram": 32,  "vram": 20, "tags": ["reasoning", "coding"], "ollama": "deepseek-r1:32b", "ctx": 8192},
    {"name": "Command R+ 104B",      "size_gb": 60.0, "min_ram": 96,  "vram": 60, "tags": ["chat", "coding", "writing"], "ollama": "command-r-plus:104b", "ctx": 4096},

    # Massive (servers)
    {"name": "DeepSeek V3 671B",     "size_gb": 404.0,"min_ram": 512, "vram": 400,"tags": ["coding", "reasoning"], "ollama": "deepseek-v3", "ctx": 4096},
]


def detect_hardware():
    """Detect system hardware specs."""
    info = {"os": platform.system(), "ram_gb": 0, "vram_gb": 0, "gpu": "none", "cpu_cores": os.cpu_count() or 4}

    # RAM
    try:
        if info["os"] == "Darwin":
            result = subprocess.run(["sysctl", "-n", "hw.memsize"], capture_output=True, text=True)
            info["ram_gb"] = int(result.stdout.strip()) // (1024**3)
        elif info["os"] == "Linux":
            with open("/proc/meminfo") as f:
                for line in f:
                    if "MemTotal" in line:
                        info["ram_gb"] = int(line.split()[1]) // (1024**2)
                        break
    except:
        info["ram_gb"] = 8  # fallback

    # GPU / VRAM
    try:
        # Apple Silicon
        if info["os"] == "Darwin":
            result = subprocess.run(["sysctl", "-n", "machdep.cpu.brand_string"], capture_output=True, text=True)
            cpu = result.stdout.strip()
            if "Apple" in cpu:
                info["gpu"] = "Apple Silicon (unified memory)"
                info["vram_gb"] = 0  # unified, RAM = VRAM
        # NVIDIA
        nvidia = shutil.which("nvidia-smi")
        if nvidia:
            result = subprocess.run([nvidia, "--query-gpu=name,memory.total", "--format=csv,noheader"], capture_output=True, text=True)
            if result.returncode == 0:
                parts = result.stdout.strip().split(", ")
                info["gpu"] = parts[0]
                info["vram_gb"] = int(parts[1].replace(" MiB", "")) // 1024
    except:
        pass

    return info


def recommend_models(hw: dict, scenario: str = "chat") -> list:
    """Recommend models that fit the hardware."""
    available_ram = hw["ram_gb"]
    if hw["gpu"] == "Apple Silicon (unified memory)":
        available_ram = max(available_ram, hw["vram_gb"])  # unified

    fits = []
    for m in MODELS:
        # Check RAM
        if m["min_ram"] > available_ram:
            continue
        # Check VRAM if discrete GPU
        if hw["vram_gb"] > 0 and m["vram"] > hw["vram_gb"] and "Apple" not in hw["gpu"]:
            continue
        # Check tags
        if scenario not in m["tags"] and "chat" not in m["tags"]:
            continue

        # Score: best fit = closest to available RAM without exceeding
        utilization = m["size_gb"] / available_ram
        score = utilization if utilization <= 0.8 else 1.5 - utilization

        fits.append({**m, "score": round(score, 3), "utilization_pct": round(utilization * 100)})

    fits.sort(key=lambda x: -x["score"])
    return fits[:8]


def generate_setup(hw: dict, model: dict) -> dict:
    """Generate setup commands."""
    cmds = {}
    is_apple = "Apple" in hw.get("gpu", "")

    # Ollama (easiest)
    cmds["ollama"] = [
        "# Install Ollama if not already",
        "curl -fsSL https://ollama.com/install.sh | sh" if hw["os"] != "Darwin" else "brew install ollama",
        f"ollama pull {model['ollama']}",
        f"ollama run {model['ollama']}",
    ]

    # llama.cpp (more control)
    quant = "Q4_K_M"
    if model["size_gb"] < 3:
        quant = "Q8_0"
    elif model["size_gb"] > 40:
        quant = "Q2_K"

    gguf_name = model["ollama"].replace(":", "-").replace("/", "-")
    cmds["llama_cpp"] = [
        "# Build llama.cpp",
        "git clone https://github.com/ggerganov/llama.cpp && cd llama.cpp && make -j",
        f"# Download {model['name']} GGUF (example — replace with actual URL)",
        f"# Then run:",
        f"./main -m models/{gguf_name}-{quant}.gguf -c {model['ctx']} -n 512 --temp 0.7",
    ]

    # LM Studio (GUI option for macOS/Windows)
    cmds["lm_studio"] = "Download LM Studio from https://lmstudio.ai and search for the model there."

    return cmds


def main():
    print("=" * 60)
    print("  LLM Deploy Helper — Find the right model for your hardware")
    print("=" * 60)

    hw = detect_hardware()
    scenario = sys.argv[1] if len(sys.argv) > 1 else "chat"
    if scenario not in ("chat", "coding", "writing", "reasoning"):
        scenario = "chat"

    print(f"\n🖥 Hardware detected:")
    print(f"   OS: {hw['os']} | CPU cores: {hw['cpu_cores']}")
    print(f"   RAM: {hw['ram_gb']} GB")
    if hw["gpu"]:
        print(f"   GPU: {hw['gpu']} | VRAM: {hw['vram_gb']} GB" if hw["vram_gb"] > 0 else f"   GPU: {hw['gpu']}")
    else:
        print(f"   GPU: none (CPU-only inference)")

    models = recommend_models(hw, scenario)

    if not models:
        print(f"\n❌ No models found for '{scenario}' on this hardware.")
        print(f"   Try 'chat' scenario or upgrade RAM/VRAM.")
        return

    print(f"\n📋 Recommended models for '{scenario}' (best fit first):\n")
    print(f"{'Rank':<6} {'Model':<22} {'Size':>6} {'RAM':>6} {'Util':>6}")
    print("-" * 50)
    for i, m in enumerate(models[:6], 1):
        icon = "⭐" if i == 1 else "  "
        print(f"{icon} #{i:<3} {m['name']:<22} {m['size_gb']:>5.1f}G {m['min_ram']:>5}G {m['utilization_pct']:>5.0f}%")

    # Best model setup
    best = models[0]
    cmds = generate_setup(hw, best)

    print(f"\n🚀 Quick setup for {best['name']}:\n")
    print("  # Ollama (recommended — easiest)")
    for cmd in cmds["ollama"]:
        print(f"  {cmd}")
    print(f"\n  # Or with llama.cpp (more control)")
    for cmd in cmds["llama_cpp"]:
        print(f"  {cmd}")
    print(f"\n  # GUI option")
    print(f"  {cmds['lm_studio']}")

    print(f"\n💡 Tips:")
    if hw["ram_gb"] < 16:
        print(f"   Your RAM is tight ({hw['ram_gb']}GB). Close other apps before running.")
    if hw["gpu"] == "none" and hw["ram_gb"] > 16:
        print(f"   CPU-only. Expect slower inference. A GPU would help a lot.")
    print(f"   Use 'llm-deploy coding' or 'llm-deploy reasoning' for scenario-specific picks.")


if __name__ == "__main__":
    main()
