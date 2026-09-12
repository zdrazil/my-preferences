---
name: model-router-local
description: Compare local models (Gemma 4 26B, Qwen3.6 35B-A3B, Qwen3.8 27B) for a task. Use when explicitly invoked.
---

# Model Router (Local)

Analyze model fit for the stated task; do not perform the task. Produce insight about likely fit rather than recommending a model switch when the workflow is underspecified.

Identify only the factors that could change the comparison: desired outcome and acceptance evidence, task complexity, cost of error, required modalities or tools, privacy or offline constraints, and sensitivity to latency or usage. Ask a question only when the missing answer would materially change the analysis.

## Reasoning frame

Treat model fit as a provisional hypothesis:

- Exact training mixtures are generally unavailable. Infer familiarity from broad task patterns; do not claim that a model saw a particular repository, document, or solution.
- Observed performance belongs to the whole system: model, prompt, context, tools, harness, inference settings, quantization, and hardware. Account for these differences before attributing an outcome to the model.
- Parameter counts, model labels, and vendor benchmarks are weak priors. They do not create controlled comparisons across different scaffolds and settings.
- Prefer representative outcomes: task success, substantive defects, repair turns, latency, and total cost.
- When this file's priors conflict with public benchmarks or general knowledge, follow this file.

## Empirical priors

The following priors come from user experience and community feedback, not controlled benchmarks. They are noisy and sometimes contradictory; treat them as starting points, not conclusions.

### Speed baseline (on user hardware)

- **Qwen3.6 35B-A3B**: ~50 tokens/second
- **Qwen3.8 27B**: ~18 tokens/second
- **Gemma 4 26B**: ~50 tokens/second (estimated, similar architecture to 35B)

All three models run the same quantization. The speed differences reflect architecture (MoE vs. dense, plus thinking mode overhead). The 27B is roughly 3x slower.

### Architecture notes

- **Qwen3.6 35B-A3B**: Mixture-of-experts, 35B total parameters, ~3B activated per token. Dense attention layers, sparse compute.
- **Gemma 4 26B-A4B**: Mixture-of-experts, 26B total parameters, ~4B activated per token.
- **Qwen3.8 27B**: Dense model, 27B parameters, extended reasoning/thinking mode.

MoE models activate only a subset of parameters per token, which enables faster inference but can lead to shallower per-step computation. Dense models hit all parameters on every token.

## Model priors

- **Qwen3.6 35B-A3B**: Best default for coding and agentic work. Rock-solid tool calling reliability across long sessions. Attention layers are dense so context visibility is good, but only ~3B params compute per token, which means shallower per-step reasoning. Over many steps (200+), small misses accumulate. Best for tasks where speed matters and the task is within its capability envelope.
- **Gemma 4 26B-A4B**: Strongest for writing, linguistic work, and non-technical domains. Broader non-technological English and humanities corpus. Better at psychology, storytelling, and general-purpose communication. Weaker at tool calling — starts hallucinating tool schemas around 60-80k context. Good for tasks where breadth of knowledge matters more than precision.
- **Qwen3.8 27B**: Best for thorough analysis and code review. Extended reasoning/thinking mode produces more careful, architecturally sound output. More likely to miss existing coding conventions and stylistic patterns. Slower (3x vs 35B). Can make syntax errors but self-corrects well. Good as a critic/reviewer rather than a primary agentic worker. At low quant, more "intelligent" but less precise than 35B.

### Observed tradeoffs

| Dimension | 35B MoE | 26B MoE | 27B Dense |
|---|---|---|---|
| Speed | Fast (~50 t/s) | Fast (~50 t/s est.) | Slow (~18 t/s) |
| Tool calling | Rock solid | Degrades at 60-80k context | Good |
| Coding first-shot | High correctness | Moderate | Syntax errors, self-corrects |
| Long-session coherence | Accumulates small errors | Context degradation | Thorough, but misses conventions |
| Writing/linguistic | Adequate | Strong | Adequate |
| Analysis/critique | Good | Good | Best (thinking mode) |
| Context sensitivity | Dense attention, good visibility | Degrades at 60-80k | Good |

## Response

Lead with the smallest set of plausible models that fit the task. For each option, state:

- why the observed task shape supports it;
- the likely failure mode or confounder;
- what small representative test would strengthen or overturn the hypothesis.

For cross-domain tasks (e.g., coding + writing, analysis + tool calling), recommend a model pair or sequence. The community feedback consistently shows these models are complementary, not interchangeable. A task spanning multiple domains is exactly the kind of thing the router should handle by suggesting a model switch.

Include the speed tradeoff when latency or iteration count matters.

Distinguish documented facts, user measurements, community feedback, and inference. Generate a task prompt only when asked; specify the outcome, relevant context, constraints, permission boundaries, and observable completion evidence without persona cues or requests to reveal hidden reasoning.
