# llm-deploy

Detect your hardware and get the perfect local LLM setup command. No more guessing RAM/VRAM/model compatibility.

> *"most annoyed I've ever been at myself for not going overboard with RAM"* — r/LocalLLaMA (227↑)
> *"284B A13B is not gonna fit on 128GB, need at least 256GB"* — r/LocalLLaMA (87↑)

## Install

```bash
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=llm-deploy-helper
```

## Usage

```bash
llm-deploy              # default: chat scenario
llm-deploy coding       # coding-optimized models
llm-deploy reasoning    # reasoning-focused models
```

## What it does

1. Detects your RAM, VRAM, GPU, CPU
2. Matches 15+ models against your hardware
3. Sorts by best fit (size vs available RAM)
4. Generates ready-to-run commands (Ollama + llama.cpp)
5. Shows utilization % so you know if you're pushing it

## Example

```bash
$ llm-deploy coding

🖥 Hardware detected:
   OS: Darwin | CPU cores: 10
   RAM: 16 GB
   GPU: Apple Silicon (unified memory)

📋 Recommended models for 'coding':

⭐ #1   Qwen2.5 7B              4.5G     8G    28%
   #2   Llama 3.1 8B            5.0G    12G    31%
   #3   Gemma 3 12B             7.0G    16G    44%

🚀 Quick setup for Qwen2.5 7B:
  brew install ollama
  ollama pull qwen2.5:7b
  ollama run qwen2.5:7b
```
