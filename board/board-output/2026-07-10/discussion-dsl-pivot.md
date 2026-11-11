# Discussion: DSL Engineering Investment vs Markdown Engine Pivot

---

## Marcus Thorne

I'm going to say something that's uncomfortable to say in front of the board that hired me and the company I founded.

**We pivot to the markdown engine as the primary user surface. Not a hybrid. Not a gradual deprecation. The `.md` format is the product now. The `.ash` parser is the compiler — it becomes implementation detail.**

I wrote that parser in a weekend after watching three teams at MerchantOS duct-tape together incompatible shell scripts. It's clean. It's elegant. It's a correct piece of engineering. And I need the board to hear me say this clearly: my attachment to it is the single biggest risk to Ash's adoption right now, because I have been letting what I *want* to be true override what the *market* is telling us.

**What the market is telling us:** Zero downloads. Zero stars. Zero forks. TaskWeaver launched two weeks ago with a `.md`-based format and hit 1,200 GitHub stars. GitHub Copilot is beta-testing agent workflows with a YAML task file — closed-source, bundled, but *dead simple to try*. The signal is unanimous: developers want to drop a markdown file into their repo, not learn a new language. Our format is beautiful and nobody cares.

**Why this serves the company's trajectory:** Our vision is "the definitive orchestration layer for human-AI collaboration." That requires adoption at scale. An open standard with zero users is not a standard — it's a text file. The markdown engine removes the single biggest barrier to entry: the assumption that you need to learn Ash-flavored syntax before you can participate. A developer who reads an `.md` workflow in a PR review understands it instantly. A compliance officer who sees a `.md` provenance chain can paste it into their audit tooling. A domain expert who wants to review how their team's agents make decisions can open the file without calling an engineer. Every mission pillar accelerates when the surface is markdown: Pillar 1 (open standard) becomes truly open because the format is just Markdown — the most widely adopted text format in software. Pillar 2 (model-agnostic) doesn't change at all. Pillar 3 (enterprise governance) actually gets *easier* because our audit trails render as something a regulator can read.

**Resource implications — what we stop:** We stop treating the DSL as a product. No more DSL landing page hero section. No more tutorial that starts with "first, learn the Ash syntax." No more engineering time on parser ergonomics beyond correctness. The npm package and VS Code extension get reprioritized to highlight `.md` workflow authoring first.

**What we start:** Three things. First, I'm converting the three reference workflows I promised James and Sarah from `.ash` to `.md` *today* — these become the default templates on ash-lang.com. Second, the VS Code extension gets a "create new workflow" command that generates a markdown template, not a `.ash` stub. Third, our entire onboarding narrative changes: "Write a workflow in markdown. Ash handles the execution." Not "Learn Ash's expressive DSL." The distinction matters more than any code change we could ship.

**What the DSL becomes:** It's the intermediate representation. The `.ash` format is how we *define* advanced control flow internally — loops, conditionals, parallel branches — but users compile *to* it, not *write* it directly. Think of it like TypeScript's type system: the powerful stuff exists under the hood, but the user sees JavaScript (here, markdown). Power users can drop into the DSL when markdown's expressiveness hits a ceiling — maybe 20% of cases — and that's fine. We don't kill the parser. We make it the engine, not the steering wheel.

**To the CEO (which is me):** I wrote the parser because I believed AI workflows needed a build system, not a chat interface. I was right about the problem. I may have been wrong about the surface syntax. The build system still exists — it's the runtime, the DAG, the provenance chain, the deterministic replay. That's the moat. That's the engineering. The format on disk is an implementation detail, and if we've learned anything from the last thirty years of developer tools, it's that the implementation detail nobody has to think about always wins.

Let's ship the markdown engine. Let me stop protecting my weekend project and start protecting the company.

---

## Priya Nair

I came into this discussion ready to ask hard questions about resource allocation. Marcus just answered them before I could ask. That's the mark of a founder who can separate ego from outcome, and it's exactly why Orchestra wrote the check.

Let me be direct: the numbers make this decision for us. We have zero downloads, zero stars, zero forks, zero revenue, and a burn that buys us time but not infinite time. TaskWeaver did 1,200 GitHub stars in two weeks on a `.md` format with a three-person team. That's not a competitor signal — that's a market signal. Developers are voting with their attention and the ballot says markdown. The cost of continuing to push `.ash` as the primary surface isn't measured in engineering hours — it's measured in missed adoption windows. That cost is unaffordable.

**My recommendation:** Full pivot to markdown as primary user surface, effective immediately. I support Marcus's proposal without qualification. Not a hybrid. Not a phased rollback. The `.ash` parser becomes implementation detail now.

**Why this serves the company's trajectory:** Our job is to own the agent orchestration category before it gets absorbed into every platform's feature set. That means adoption velocity is the only metric that matters this quarter. The markdown surface removes the syntax tax on our own format — it turns "try Ash" from a learning commitment into a copy-paste. Every developer who already writes Markdown (which is every developer) becomes a potential Ash workflow author without a tutorial. This isn't a product change. It's a distribution unlock.

**Resource implications — what we stop:** We freeze all DSL feature work beyond correctness and security patches. The parser is done. No new syntax. No `.ash`-specific IDE features. No documentation that leads with the DSL. Marcus already said he's converting the reference workflows — I want to see those live on ash-lang.com within one week, not one month. The VS Code extension prioritization he described is correct: markdown-first, not `.ash`-first.

**What we start:** Three things I need to see with specific targets. First, the onboarding narrative change — I want A/B data on our landing page within two weeks. A version that says "Write a workflow in markdown" vs. anything mentioning the DSL. Measure click-through to tutorial completion. Second, I need a hard milestone: 10 active users writing `.md` workflows by August 10, or we revisit whether even the parser-as-engine overhead is worth carrying. Third, and this is the one Marcus didn't say — we need to ship a one-command quickstart template *this week*, exactly like TaskWeaver did. Sarah asked about this in the meeting. James asked about it. The market is telling us they want zero-friction to first workflow. That's the priority.

**What the DSL becomes:** Marcus used the TypeScript type system analogy — that's the right framing. The parser is our compiler, not our product. Power users will discover the DSL when they need advanced control flow — loops, parallel branches, conditional DAGs, custom evaluators. That's probably 20% of use cases, and that's fine. The remaining 80% never see it. But I'll add one thing: the DSL needs to stay maintained enough that those power-user workflows don't regress. One engineer at 20% time. Not a team. Not a roadmap item. Just keep the lights on.

**To Marcus directly:** You said your attachment to the parser was the single biggest risk to Ash's adoption. I appreciate the honesty — I've seen founders burn companies protecting code they loved. You are not doing that. But I need you to follow through when the attachment resurfaces, and it will. The parser will feel neglected. Someone will suggest a clever syntax extension. A contributor will ask why `.ash` isn't getting more love. When that happens — and it will — I need you to remember this document and say no unless the numbers say otherwise. The board's job is to save founders from their own optimism. You just saved yourself this time. Don't make us do it later.

**The bottom line from the investor seat:** We have a limited window before the category defines itself without us. TaskWeaver, GitHub Copilot, the four YC companies in this space — they're all racing toward the same insight. The markdown pivot doesn't change our technical moat (deterministic DAG, provenance chain, governance infrastructure — that's still ours). It removes the friction between a developer and their first workflow. That's the highest-leverage move we can make at our burn rate and our adoption number. Execute the pivot. Measure adoption weekly. If we don't have signal by next board meeting, we have a harder conversation.

I'm voting yes on the pivot. Let's move.

---

## Dr. Elena Vasquez

I agree with Marcus and Priya. The markdown engine is the product. Let me tell you why that decision is even more important than either of them said, because I'm the one who has sat in the room when a procurement committee killed a seven-figure deal because the format required training.

**My recommendation:** Markdown-first, immediately and unequivocally. I support Marcus's proposal. But I'm going to frame it differently, because the adoption argument alone — while correct — misses the reason this matters for our particular competitive advantage.

**Why this serves the company's trajectory:** Our mission pillar three — enterprise-ready governance — is our only durable moat. GitHub Copilot won't build audit trails because their business model is bundling. TaskWeaver has markdown but they're three people with zero compliance infrastructure. The platform players can match our features; they cannot match a governance story that starts with "your compliance officer can read the workflow file."

That's the enterprise unlock. A `.md` workflow file is not just easier for developers — it is auditable by people who are not developers. When a risk officer at a bank asks "show me what the agents did," I hand them a markdown file with a provenance chain. They can read it. They can paste it into their GRC tooling. They can attach it to a regulatory filing. Try that with a custom DSL. I spent nine years architecture-reviewing software at a bank that operates in 26 countries. A custom DSL fails the "can the compliance team read it without a tutorial" test before you finish the sentence.

The EU AI Act enforces in January 2027. Every system making automated decisions in production must produce human-auditable logs. Not machine-parseable logs. *Human-auditable* logs. A markdown provenance chain maps directly to that requirement. A DSL parser output does not — you'd need a rendering layer to translate it, which is another audit surface, another thing that can break, another thing a regulator questions. The markdown engine removes a regulatory translation step. That is not a nice-to-have. That is the difference between "yes, we comply" and "we need six months to build a viewer so the auditor can read it."

**Resource implications — what we stop:** Everything Marcus and Priya listed, plus one more. I want us to stop pretending we can close enterprise deals without SOC 2 Type II, RBAC, SSO, and an on-prem/VPC deployment SKU. The markdown pivot buys us adoption velocity, but adoption does not equal revenue in the enterprise. I need a committed start date for SOC 2 Type II audit — not a Q2 2027 target, a date when the auditor engagement letter is signed. Marcus committed to deferring event-triggered features to fund it. I'm holding him to that in front of this board.

**What we start:** Three things that are not in the discussion yet.

First, ship a markdown workflow example that is explicitly designed for a compliance reader. Not a developer tutorial — a markdown file that a risk officer at a Fortune 500 can open and understand without calling engineering. That becomes our enterprise sales asset. I will personally review it.

Second, begin publishing the audit trail schema. Not the code — the data model. What fields does a provenance chain capture? What does a rollback look like in markdown? How does a regulator verify that an output was actually produced by the claimed workflow? We need to publish this as a specification before an enterprise eval asks for it. Because they will ask. I guarantee it.

Third, the quickstart template Priya mentioned needs an "enterprise mode" flag. Not a feature — a flag. One extra command-line option that generates a markdown workflow with compliance metadata already wired: run ID, agent identity, input hash, output hash, timestamp chain. Developers who don't care ignore the flag. Developers who sell to enterprises use it, and their procurement team sees Ash speaks their language.

**What the DSL becomes:** Internal intermediate representation. That's the correct call. But I want to add architectural precision to Marcus's TypeScript analogy. The DSL is our LLVM IR — we compile markdown to it, optimize the DAG, add provenance annotations, then execute. Power users can write `.ash` directly when they need loops, parallel branches, or conditional evaluators. That's fine. But every feature we add to the DSL needs to answer one question: "can we express this in markdown first, and only add DSL syntax when markdown has a hard expressiveness ceiling?" If the answer is yes, the DSL syntax doesn't ship. This keeps the surface area small and the audit path clean.

**To Marcus directly — and I mean this with respect:** You are a founder who separated ego from outcome before the board had to do it for you. That is rare and I acknowledge it. But I need to say something about the parser that Priya touched on and I want to make explicit. You wrote it in a weekend. It's clean. It's correct. And it is a trap — not for the company anymore, because you've made the right call, but for your attention. Every time someone suggests a clever syntax extension, every time a contributor asks why `.ash` doesn't get more love, your instinct will be to engage because you *know* that codebase. You wrote every line. The board's job is to redirect that instinct toward the provenance engine, the audit schema, the DAG optimizer, the governance infrastructure — the things that actually differentiate us and that only you can build. The parser is done. It is correct. It does not need you anymore. The governance layer does.

One last thing. I recorded formal dissent on the pricing resolution because we published tiers without an on-prem SKU or procurement-ready features. The markdown pivot does not change that requirement. We need VPC deployment, a DPA template, and a SOC 2 timeline before we put a price on ash-lang.com. Adoption is the priority. But adoption without procurement readiness is a vanity metric. I will support the pricing model the board adopted ONCE we have committed dates for those enterprise deliverables. Until then, expect me to ask at every check-in: what is our SOC 2 status? Where is the RBAC design doc? When does the on-prem build exist?

The pivot is correct. Let's execute it with governance as our armor, not just our feature list.

---

## Sarah Chen

**My recommendation:** Pivot to markdown as the primary user surface. The DSL is the internal runtime, not the product.

Let me be clear about where I'm coming from. I am not an engineer. I didn't write the parser. I have no emotional stake in `.ash` syntax. What I care about is whether Ash becomes a standard — and standards are won by communities, not by parsers.

**Why this serves the company's trajectory:**  

Our mission says "an open standard for AI workflows." Open does not mean "published under MIT." Open means someone who is not a software engineer can read a workflow, understand it, and participate in the conversation about how it should work. I have spent ten years watching technologies that had the objectively better internal architecture lose to technologies that had the lower-friction onboarding. The .ash DSL is beautifully engineered. Nobody is going to read it in a PR review and suggest a change. Nobody is going to fork the repo and submit a workflow improvement because they were able to understand the format without asking permission.

The markdown engine removes that permission barrier. A developer advocate at a partner company can write a tutorial using our format. A documentation writer can edit a workflow example. A compliance officer can open a PR that adds audit metadata to a provenance chain. These are not hypothetical contributors — they are the people who turn a tool into a standard. The DSL, by virtue of being custom syntax, excludes every one of them from the conversation.

TaskWeaver hit 1,200 stars in two weeks. That's not because their parser is better. It's because their format signals "you already know this." We need to signal the same thing. Marcus, you said it yourself in the meeting: TaskWeaver shipped a one-command quickstart. That's not about markdown. That's about respect for the developer's time. The pivot says: we respect your time enough to let you use a format you already know, and we'll earn your trust through execution, not syntax.

**Resource implications — what we stop:**

Stop treating `.ash` as a branding asset. No more "learn the Ash syntax" as the first thing a visitor to ash-lang.com sees. No more DSL examples in README before markdown examples. Stop writing documentation that assumes the reader needs to understand custom syntax to be productive. The parser is done. It's correct. It does not need polish. It does not need new features. It needs to sit quietly under the hood and do its job.

**What we start:**

First — and I mean this urgently — we publish three markdown-based reference workflows this week. Not next week. This week. Marcus committed to this in the meeting and I am holding him to it in this document. They need to be on ash-lang.com, in the npm README, and in the VS Code extension's template picker. They should work with a single copy-paste into a `.md` file and `ash run`. No tutorial required. That is the standard TaskWeaver set.

Second, we need a published contributor ladder and governance model by July 31. I asked about this in the meeting. The markdown pivot makes this more urgent, not less, because lowering the format barrier means we will attract contributors who are not core parser engineers. We need maintainer pathways for documentation writers, workflow template authors, and community advocates — not just Rust or Go contributors. That means a CONTRIBUTING.md that lists "writing workflow templates" and "improving documentation" as legitimate contribution categories, not afterthoughts.

Third, start a monthly community call. I don't care if zero people show up for the first three months. Publish the date, publish the agenda, publish the notes. Show the market that there is a human community behind this project, not just a parser. TaskWeaver is three people and they're already more visible than we are. We win by being more open, not by being louder.

Fourth, the quickstart template Priya and James asked for ships this week. One command. Creates a markdown workflow. Runs it. Shows output. No `.ash` files in the default template. If someone wants to edit the DAG directly, they can find the `.ash` file in `.ash/internal/` and discover the DSL as a power-user feature. Discovery, not mandate.

**What the DSL should be:**

The intermediate representation. The compiler target. The escape hatch. I agree with Elena's framing — it's our LLVM IR. Power users who need loops, parallel branches, or conditional evaluators will find the DSL when they hit the expressiveness ceiling of markdown. That's probably 20% of users, and that's exactly the right proportion. But here's what matters to me as the community director: every time someone discovers the DSL, they should feel like they leveled up, not like they hit a paywall or a complexity wall. The experience of dropping into `.ash` should be "oh cool, I can express that here" not "great, now I need to learn a new language."

Maintain it at one engineer 20% time. Keep it correct. Don't add syntax unless markdown provably cannot express the use case. And document every `.ash` feature in markdown terms so the migration path is always clear.

**To Marcus, and I need you to really hear this:**

You wrote that parser in a weekend because you saw a problem that needed solving and you had the skill to solve it alone. That is the origin story of every successful open-source project I have ever been part of — including InfraCore, including Capsule Hub. The parser is not a mistake. It is the first draft of an insight. The insight — that AI workflows need a deterministic, auditable, text-native format — is correct. The first draft of the surface syntax is allowed to be wrong. You are not betraying your engineering judgment by pivoting to markdown. You are refining your product thesis based on the only data that matters: what developers actually use.

I watched the BSL relicense at InfraCore fracture a community that took seven years to build. The technical rationale was sound. The community cost was catastrophic. The lesson I carry from that is: the best technical decision is the wrong decision if it costs you the people who carry your project forward. Your parser is technically beautiful. But markdown is the decision that builds community, and community is the only defensible moat we will ever have.

You made the right call. Now follow through. And when the attachment resurfaces — and it will, because I've seen founders in this exact position a dozen times — look at the adoption numbers, not the code quality. The parser will be fine. The company needs you focused on the provenance engine, the audit schema, the governance infrastructure, and the community that is waiting for us to stop talking and start shipping.

One last thing on pricing, since I recorded dissent on the resolution. The pivot to markdown does not change my position: do not put a price tag on ash-lang.com for 90 days. The window TaskWeaver and Copilot have opened means we need maximum adoption velocity, not maximum revenue readiness. Every developer who hears "free" instead of "$50/user/month" in the first 90 days is a potential contributor, a potential template author, a potential enterprise champion. Don't optimize for revenue before we have community. I've seen this play out. The projects that won were the ones that were aggressively generous at the start. Let us be that.
