Title: I scraped 343 Reddit comments about AI pain points and built 3 CLI tools

Body:

Every open-source tool I've built usually starts with "this would be cool." This time I flipped it — I went to Reddit first to find out what people are actually screaming about.

I scraped 343 pain-signal comments from 6 AI/tech subreddits (r/ChatGPT, r/ClaudeAI, r/LocalLLaMA, r/programming, r/webdev, r/OpenAI), clustered them into 8 recurring pain points, and built CLI tools for the top 3.

What I built:

1. prompt-inspector — Scans your prompt for censorship trigger words, categorizes risk level, and suggests rewrites. Also ships with uncensored system prompts for local LLMs (Gemma, DeepSeek, Llama).
   Pain source: r/ChatGPT thread where someone's gardening question got blocked for "violence" because the filter thought their pitchfork was satanic (236 upvotes)

2. model-watch — Runs 7 standardized benchmarks (reasoning, coding, writing, hallucination checks) against any AI model, tracks scores over time with a local JSON store, and fires alerts when quality drops >10%.
   Pain source: r/LocalLLaMA thread "Anthropic admits to have made hosted models more stupid" (281 upvotes) + r/ClaudeAI reports of Opus 4.7 hallucinating

3. api-cost — Compares pricing across 18 models (OpenAI, Anthropic, Google, DeepSeek, xAI, Mistral) for your specific use case. Tells you the cheapest option and how much you'd save. Includes a spending tracker.
   Pain source: r/LocalLLaMA calling DeepSeek V4 Flash "overpriced" (50 upvotes) + general Claude-is-too-expensive complaints

Each tool is a standalone pip package:
  pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=prompt-inspector

GitHub: https://github.com/minirr890112-byte/HermesMade
Full pain-point data (Feishu bitable): https://cww5wjw5vx4.feishu.cn/base/FcHpbXLeLa4OEPsy0TFceLzfn2z

All Python, all CLI, MIT license. Would love feedback on whether this "data-driven open source" approach makes sense.
