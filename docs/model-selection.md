# Backend model selection

Decision date: 2026-09-10. Default: `gpt-5.4-mini-2026-03-17`.

ContextLens needs bounded structured extraction, summaries, action items, and error explanations. GPT-5.4 Mini supports structured output and image input, with a dated snapshot for repeatable evaluation. It is a reasonable cost-conscious starting point for this workload. The initial integration will send extracted text, not automatically upload original images.

The official catalog lists GPT-5.4 Mini at $0.75 input / $4.50 output per million text tokens, compared with GPT-5.6 Terra at $2 / $12 when checked. Choosing the smaller model here is an engineering hypothesis to validate against the synthetic evaluation corpus, not a claim of measured accuracy or superiority. Revisit it if extraction or explanation quality fails the recorded evaluation criteria.

Sources: [GPT-5.4 Mini](https://developers.openai.com/api/docs/models/gpt-5.4-mini), [GPT-5.6 Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra).

`OPENAI_MODEL` is a backend-only optional override. Missing, empty, or whitespace-only values select the default; a non-empty value is retained after trimming whitespace. No model identifier or provider key is required in the iOS app. Account access is not assumed or tested during configuration. Normal CI blocks external network connections and uses synthetic data; live integration validation belongs to the cloud milestone.
