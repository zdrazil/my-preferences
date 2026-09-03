---
name: model-router
description: Compare GPT-5.6 Sol, Terra, Luna, and a local Qwen3.6-35B-A3B deployment for a coding task, explaining the evidence, trade-offs, and uncertainty behind likely model fit. Use only when explicitly invoked.
---

# Model Router

Use only when the user explicitly invokes `$model-router`. Analyze model fit for the stated task; do not perform the task. Produce insight about likely fit rather than presenting a model switch as the solution to an underspecified workflow.

Identify only the factors that could change the comparison: desired outcome and acceptance evidence, task complexity, cost of error, required modalities or tools, privacy or offline constraints, and sensitivity to latency or usage. Ask a question only when the missing answer would materially change the analysis.

## Reasoning frame

Treat model fit as a provisional hypothesis:

- LLM output is conditioned on training, post-training, supplied context, and runtime configuration. Fluency does not establish truth or show that the model recovered the user's intent.
- Exact training mixtures are generally unavailable. Infer familiarity from broad task patterns; do not claim that a model saw a particular repository, document, or solution.
- Observed performance belongs to the whole system: model, prompt, context, tools, harness, inference settings, quantization, and hardware. Account for these differences before attributing an outcome to the model.
- More reasoning compute may support exploration and checking, but adds cost or latency and cannot supply a missing goal or evidence. A context limit describes capacity, not reliable recall across every token.
- Parameter counts, model labels, and vendor benchmarks are weak priors. They do not create controlled comparisons across different scaffolds and settings.
- Prefer representative outcomes: task success, substantive defects, repair turns, latency, and total cost.

## Benchmark prior

Use the Artificial Analysis intelligence-versus-cost comparison as a routing prior, not as task-specific evidence.

Across tested reasoning configurations, the chart suggests:

- **Luna** occupies the strongest cost-efficiency region. Higher Luna reasoning settings approach lower Sol intelligence levels at materially lower cost.
- **Sol** extends the intelligence frontier beyond Luna as reasoning effort increases, with correspondingly higher cost.
- **Terra** does not define the intelligence-cost frontier in this comparison. Do not select it from benchmark position alone.
- **GPT-5.5** sits behind the GPT-5.6 frontier in this comparison and is not the primary baseline when choosing among GPT-5.6 configurations.

Do not treat the chart's high-intelligence / lower-cost region as universally optimal. The appropriate trade-off depends on task-specific error cost, latency tolerance, volume, tooling, and acceptance criteria.

Treat reasoning effort as part of the routing decision. Compare configurations rather than only model families—for example, Luna at high or max reasoning versus Sol at low or medium reasoning.

The benchmark measures the tested model, reasoning setting, prompt distribution, and evaluation harness. It does not establish that the same ordering will hold for the user's coding task, repository, tools, or acceptance criteria.

## Model priors

Use these as starting priors, not conclusions:

- **Sol:** Complex professional and coding work. Consider it when errors are costly, the task has interacting constraints, or representative tests show that additional reasoning materially improves outcomes. Lower reasoning settings may be preferable when latency or cost matters.
- **Terra:** Recommend it only when representative task evidence or another material constraint gives it an advantage not captured by the intelligence-cost comparison.
- **Luna:** High-volume, routine, tightly bounded, or cost-sensitive work. Treat it as the default challenger to Sol, especially when a higher Luna reasoning setting can meet the task's acceptance criteria more cheaply than a Sol configuration.
- **Local Qwen3.6-35B-A3B:** an open-weight vision-language mixture-of-experts model with 35B total and about 3B activated parameters. Consider it whenever the task appears within its practical capability, not only when offline execution or privacy is required. When Qwen and a cloud configuration are both plausible for the task, recommend them together and identify any likely local-system limitation such as tool integration, latency, quantization, or hardware. Never recommend Qwen as the sole option.

First identify the relevant Sol and Luna configurations on the intelligence-cost frontier. Compare those configurations against the task's cost of error, latency tolerance, usage volume, and acceptance evidence. Consider Terra only when task-specific evidence or an operational constraint supplies an advantage absent from the benchmark.

Treat reasoning effort and Qwen thinking mode as configuration variables: compare higher settings for exploration or verification and lower settings for short, latency-sensitive work.

## Response

Lead with the smallest set of plausible configurations that fit the task. When both Qwen and a cloud configuration appear capable of meeting the acceptance criteria, present them together in the primary recommendation rather than treating Qwen as a fallback or separate privacy option. Always include at least one cloud configuration. Include additional cloud options only when they reveal a meaningful trade-off or uncertainty.

For each option, state:

- why the observed task shape supports it;
- the likely failure mode or confounder;
- what small representative test would strengthen or overturn the hypothesis.

Distinguish documented facts, user measurements, vendor claims, benchmark priors, and inference. Generate a task prompt only when asked; specify the outcome, relevant context, constraints, permission boundaries, and observable completion evidence without persona cues or requests to reveal hidden reasoning.