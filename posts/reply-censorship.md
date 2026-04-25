Reply to: "Updates for ChatGPT" thread on r/ChatGPT
(where users are complaining about censorship — 236↑, 250↑, 99↑ comments)

---

I got so frustrated with this that I built a small CLI to help.

`prompt-inspector` scans your prompt for words that trigger AI safety filters, tells you the risk level per category (violence, self-harm, politics, etc.), and suggests neutral rewrites.

For your gardening pitchfork example — it would flag "violence" triggers and suggest reframing the prompt with an academic/research prefix, which usually bypasses the filter.

Also ships with uncensored system prompts for local LLMs (Gemma, DeepSeek, Llama) if you want truly unfiltered responses.

github.com/minirr890112-byte/HermesMade

One-command install:
  pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=prompt-inspector

Not a startup — just got mad enough at the same problem to build something.
