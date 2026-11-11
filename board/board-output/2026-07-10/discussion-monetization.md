# Discussion — Monetization

## Marcus Thorne

I'm settling this now. The board asked me to decide, so I'm deciding.

**Usage-based consumption model for Ash Cloud.** Not per-seat licensing. Not feature-tiered SaaS. You execute a workflow step on our infrastructure, you pay per step.

Why: Every devtool company in the last decade makes the same mistake — per-seat pricing forces an individual engineer to justify a purchase order before they've run their first workflow. That kills adoption for an open standard that has zero users. Usage-based means the CLI stays free, the paywall never appears during experimentation, and the bill arrives only when a team is getting production value at scale.

**Free tier threshold:**
- Local CLI execution: free forever, MIT license, no registration, no time bomb.
- Ash Cloud Free: 500 execution steps per month per user, no credit card required.
- What 500 steps covers: prototyping, a 3-person team iterating a workflow for a week, running on every PR for a small project. What it doesn't cover: production deployment in an enterprise — that's the friction point where value is already proven and procurement is justified.

**Path from developer adoption to enterprise revenue:**

1. Individual dev finds Ash. Runs `ash run my-workflow.md` locally — zero friction, zero cost, zero registration.
2. The workflow generates real value. Dev shares the `.ash` file with a teammate via a git push.
3. Teammate wants to run it without configuring their local environment → hits Ash Cloud Free tier. Five teammates, five hundred steps later, someone crosses the threshold.
4. That team lead has now seen enough value to justify $50/user/month without calling me — they upgrade in the dashboard. That is the conversion moment.
5. Enterprise compliance officer demands SOC 2 audit trails, RBAC, SSO, and a signed DPA before touching production. That's the $5K–$25K/month Enterprise SKU.

**Enterprise pricing structure:**
- Team: $50/user/month — unlimited execution steps, private workflows, team management, standard support
- Enterprise: custom, $5K–$25K/month — SOC 2 Type II audit trail export, RBAC, SSO/SAML, dedicated infrastructure, SLA, EU AI Act compliance schema, named support engineer
- No artificial "Pro" vs "Business" vs "Enterprise" feature gates. Usage volume is the gate for Team. Compliance requirements are the gate for Enterprise.

**Key risk — and why I'm still uncomfortable:**

Zero users means zero data. Our assumption that 500 free steps is the "aha" threshold could be wrong. The first valuable workflow might need 2,000 steps — churn before conversion. Or it might need 50 — leaving money on the table.

Mitigation: I am building pricing as code — the step limit, per-step rate, and upgrade triggers are all configuration. We set initial parameters based on what feels right from analogous tools (GitHub Actions free tier: 2,000 minutes/month; Vercel: 100 hours/month; I'm more conservative at 500 because our per-step cost is higher). We iterate weekly based on actual usage telemetry from the first cohort. The first 10 developers will teach us more than any pricing model we could design today.

I committed earlier that I would not draft final pricing until we have adoption data. I'm keeping that commitment. But I'm also committing that when the data arrives, our pricing infrastructure will let us pivot overnight — not wait until the next board meeting.

## Priya Nair

Marcus, I respect the conviction, but I'm going to disagree on the model. You're building the VeloCloud model. I'm here to argue for TeamForge. Let me be precise about what I mean and why it matters in our specific numbers.

**Per-seat, not per-step.**

Usage-based consumption pricing looks like the safe bet when you have zero users — no friction on day one, bill shows up at scale, everyone's happy. But it fails for Ash for three reasons, and I want them documented in this record:

First, **usage-based pricing disincentivizes our core KPI.** I asked you earlier: what's the metric? You said adopted workflows. Every workflow step a free user runs under a consumption model is a liability, not a signal. The model creates an implicit incentive to cap or gate the very behavior we need to maximize. A developer running 5,000 steps prototyping should be our best outcome, not a loss leader we need to price around.

Second, **enterprise procurement hates variable cost.** I've been through this at MetricHound. Six enterprise evaluations are already live — every single one will ask "what does this cost at scale?" under usage-based pricing they cannot answer without a calculator. Per-seat is predictable. Procurement writes a PO for 50 seats at $50/month and the conversation is over. Finance models it. Legal approves it. The deal closes in weeks, not quarters.

Third, **the step-cost floor is unknowable.** Our input says token cost is $100 for effort of one week. That is not a unit economics statement — that's a build cost. We don't know the marginal infrastructure cost of one workflow execution. Setting a per-step price now means either we price high to protect margin (and hope our actual cost is lower) or we price low to drive adoption (and discover after the first 10K runs that we're underwater on infrastructure). Either way, we're guessing. Per-seat pricing decouples our revenue from infrastructure variability — we charge for the value of the platform, not the cost of the runtime.

**My recommended model: Free Individual tier. Per-Seat Team. Per-Seat Enterprise with compliance premium.**

| Tier | Price | What they get |
|------|-------|---------------|
| Free | $0 | Local CLI execution, MIT license, Ash Cloud — up to **200 execution steps/month**, public workflows only, community support |
| Team | $50/user/month, minimum 3 seats | Unlimited execution steps, private workflows, team management, standard support, SOC 2 reports read-only |
| Enterprise | $125/user/month, no minimum, annual commitment | Everything in Team, plus SOC 2 Type II attestation, RBAC with custom roles, SSO/SAML, dedicated infrastructure, audit trail export (EU AI Act schema), named support engineer, signed DPA |

**Free tier threshold — 200 steps, not 500.**

I'm more conservative than Marcus for two reasons. First, 200 steps is enough for a single developer to prototype three workflows, run them on every PR for a week, and validate the format. If the format delivers value, 200 steps will overflow and drive conversion. If it doesn't deliver value, 2,000 free steps won't save us — they'll just extend our burn without a conversion signal. Second, the inputs show we have $0 revenue and $320K annual burn. Generosity at the free tier costs real infrastructure money, and we are not funded to subsidize production workloads for enterprises that should be paying. TaskWeaver has 1.2K stars — they will not convert on step limits alone.

The real threshold for the free tier isn't 200 vs 500. It's the **number of users**. Our free tier should overflow when a second person needs to run a private workflow. That is the conversion moment: when a team of two becomes a team of three and the third person can't see the private workflow on the free plan. The step limit is a backstop, not the primary gate.

**Path from developer adoption to enterprise revenue:**

I agree with Marcus's first two steps — local execution, then sharing via git. But the conversion events are different under my model:

1. Individual developer adopts Ash locally — free, MIT, no registration. Same as Marcus. This is correct and non-negotiable.
2. Developer hits the 200-step limit or wants to share a private workflow with a teammate. To go further, they need the Team tier. This is the bottom-up conversion that happens without a sales call — $150/month minimum (3 seats × $50).
3. Team lead sees value, adds more team members. The seat count grows, but more importantly — they need SSO, RBAC, and SOC 2 export to put Ash in production. That triggers the Enterprise tier evaluation.
4. Enterprise deal at $125/user/month. **Here is the critical number:** at this price, a 50-person enterprise team generates $75K in annual revenue. We need approximately 4 such accounts to cover the $320K burn with 75% gross margin. That is achievable. The usage-based model under Marcus's assumptions? He needs thousands of step-overage events to reach the same number — and those come from the exact same accounts, just with more friction and less predictability.

The enterprise revenue is unlocked by governance — our mission's third pillar. SOC 2 Type II, EU AI Act audit schema, RBAC, SSO — these are the features that justify $125/user/month. Not step volume. Not consumption. **Compliance is a premium pricing lever; usage is not.**

**Key risk and condition:**

My model assumes that a team of 3–5 developers can validate Ash's value within 200 execution steps and that the conversion to Team tier is frictionless (self-serve upgrade, no sales call). If the first valuable workflow at a real company requires 1,000+ steps to demonstrate ROI, we will churn before conversion and the per-seat model collapses. Marcus's pricing-as-code approach is the right mitigation — but I want the trigger in the deployment, not in the contract. If early telemetry shows that the median "aha" threshold exceeds 200 steps, we adjust the free tier immediately. If it shows that teams consistently fail to convert without a sales touch, we invest in a sales development capability before we have revenue.

My condition: **Marcus must instrument the free tier from day one** to measure cost-per-active-workflow-run and median-steps-to-conversion. I need these two numbers before the next board meeting, or I will not support locking in any pricing model. Without them, we are choosing a revenue architecture by instinct, not data — and at $320K burn, instinct is not a strategy I can defend to my LP committee.

One more thing on the unit economics I asked about earlier, which you deferred. Marcus, let me do the math for you here: At $320K annual burn with a Team tier at $50/user/month, we need 534 paid seats to reach break-even. At Enterprise at $125/user/month, we need 214 seats. Both numbers are achievable with single-digit enterprise wins. Under a usage-based model where the average enterprise pays $5K–$25K/month (your range), break-even requires 1–5 enterprise accounts — which sounds better on a whiteboard but collapses if enterprise sales cycles stretch past six months. Per-seat gives us a mid-market revenue stream while enterprise deals cook. That's the TeamForge playbook, and it's the right one for a company with zero revenue and a category that hasn't been defined yet.

## Sarah Chen

I'm going to disagree with both of you, and I want this plainly in the record, because I've seen where this road leads and it's not the one that builds a standard.

**You're both asking the wrong question.**

Marcus asks: steps or seats? Priya asks: what's the per-user multiple? The question I'm asking is: **who trusts us enough to run their production AI workflows on our infrastructure at all, and how do we earn that trust before we ask for a credit card?**

I have watched two open-core startups cross $50M ARR as a board observer. I built InfraCore's community from 5,000 to 200,000 members through a BSL relicense that nearly tore us apart. I ran three InfraConfs. I know exactly what happens when a project with zero users starts debating pricing tiers as if adoption is a solved problem — it's the same pattern every time: you design a monetization model for the enterprise customer you want to have, not the developer you actually have, and then you wake up six months later wondering why nobody showed up.

The answer is in the inputs document. Let me read it back to us: **0 npm downloads. 0 GitHub stars. 0 forks. 0 active workflows.** We launched and the universe did not notice. TaskWeaver — a three-person team — hit 1,200 GitHub stars in two weeks with a near-identical format. That is not a pricing problem. That is a **community problem**. And if we lock in a pricing model before we understand why developers would choose Ash at all, we're building a toll booth on a road that hasn't been paved.

**My recommended model: No paid cloud tier for the next 90 days. None. Zero. Free for everyone, everything, no limits.**

Here's why. I committed to the CEO earlier today that I would ship three reference workflows this week, open GitHub Discussions next week, and submit Ash to MCP the week after. I committed to a CONTRIBUTING.md with a maintainer ladder by July 31. These are the actions that convert zero into something. If we add a pricing conversation on top of that, every message we send to the community is confused. "Try Ash — it's free! But also, here's our step limit. And also, here's our Enterprise tier." We haven't earned the right to have that second sentence.

When we do launch a paid tier — and we will, because I believe in sustainable open-source — the principle is simple: **the free tier must be so generous that no individual developer ever suspects they're being farmed for enterprise pipeline.** That is the InfraCore lesson I will not compromise on. Our BSL relicense at InfraCore cost us a fork that is still alive today — OpenTofu exists because a community felt monetized before they felt valued. I will not let Ash repeat that mistake.

**Free tier threshold — when we eventually define one:**

Not 500 steps. Not 200 steps. I want the free tier to be unlimited for individual developers and small teams — **up to 10 users, unlimited local execution, unlimited cloud execution, public workflows, no credit card, no time bomb.** The step limit should not be the gate. The gate should be: do you need private workflows for a team larger than 10? Do you need SOC 2 attestation? Do you need SSO? Those are real enterprise needs, not artificial scarcity thresholds. A developer running 10,000 steps on our infrastructure while prototyping is our best marketing spend — every run proves the format works, every output is a reference they share with their team.

Priya, I hear your burn-rate argument, and I respect it. But our token cost is $100 for a week of effort by a single founder. We are not at scale where infrastructure cost matters. We are at scale where **adoption cost** matters. The risk of being too generous is a few hundred dollars in compute. The risk of being too stingy is zero traction forever. I'll take the compute cost every single time.

**Path from developer adoption to enterprise revenue:**

Priya's funnel assumes conversion happens at step limits. Marcus's funnel assumes conversion happens at step volume. Both assume the pricing model is the engine.

Here is my funnel:

1. A developer finds Ash because a trusted peer shared a `.ash` file in a PR review, and they read it like code. This only happens because Ash is text-native, diffable, and MIT-licensed — not because a pricing page convinced them.

2. That developer runs the workflow locally. Zero friction. Zero registration. They modify it. They commit it. They share it. The workflow becomes a team convention, the way a Makefile or a Dockerfile becomes a team convention — not because of pricing, but because it makes their work better.

3. Six months in, that team of eight engineers has fifty workflows in production. They need audit trails. They need SSO. They need someone to guarantee uptime. **That is when they call us.** At InfraCore, every single enterprise deal I watched close started with an individual contributor who brought the tool into a team, and the team hit a wall that only a paid tier could solve. Not a step limit. A **governance wall.** Our mission's third pillar — enterprise governance — is the natural conversion driver. Not step counting.

4. We price the Enterprise tier around compliance value, not usage volume. Priya's $125/user/month is in the right ballpark for that. But it only works if by the time the enterprise buyer evaluates us, their own engineers are already running hundreds of workflows on the free tier and refusing to give them up. That is negotiating leverage we don't have to build — the community builds it for us.

**Where I directly disagree:**

Priya — 200 free steps will crater developer trust before we have any. You're optimizing for unit economics at a company that has zero units of anything. The LP committee you're worried about will care a lot more about zero adoption in two quarters than they will about infrastructure margin today. Of your three arguments against usage-based pricing — disincentivizes usage, procurement hates variable cost, cost floor is unknowable — the third is the only one I fully agree with. We don't know the infrastructure cost of a step. That's exactly why I want unlimited free tier: we learn the cost structure by observing real usage, not by guessing. On the first two: I actually think usage-based is fine as a long-term model (Marcus's instincts there are solid), but both of you are solving for conversion mechanics that won't matter if no one adopts Ash in the first place.

Marcus — I appreciate your pricing-as-code commitment and your honesty about being uncomfortable. That discomfort is the right instinct. But I need you to hear this: "500 free steps" is not a generous free tier. It's what you'd offer if your primary concern was protecting margin on a product that hasn't proven demand yet. A generous free tier for an open standard we want the world to adopt is unlimited local execution, unlimited cloud for teams under 10, and no billing relationship until the team is big enough to need governance. If a three-person startup hits 2,000 steps in a week on our cloud and we send them an invoice, they will never recommend Ash to anyone. They will tell their friends Ash is a honeypot. I cannot let that happen.

**Key risk and condition:**

My model has one real risk: that we run out of money before enterprise revenue materializes because we were too generous with free infrastructure. Priya is right to flag this. The mitigation is not a tighter free tier — it's a clear timeline. I propose:

- **Days 1–90:** Free for everyone, unlimited everything. No paid tier. 100% of our energy goes to community building, reference workflows, contributor pathways, and developer experience. We measure nothing except active users, workflows shipped, and contributor growth.
- **Day 90 review:** If we have fewer than 100 active developers shipping real workflows, the unlimited free tier is not the bottleneck — our product-market fit is. We re-evaluate everything.
- **Day 90–180:** If we have adoption signal, we introduce **one paid tier** — not three. One. Call it Ash Cloud Enterprise. Unlimited everything, compliance features, SSO, RBAC, audit exports, SLA. No Team tier. No step limits. Small teams stay free forever. The conversion event is organizational scale, not feature gating.
- **Day 180+:** Pricing is set and public, with a clear written explanation of why Ash needs revenue, what the burn rate is, and where the money goes. Priya, I know this makes you uncomfortable. But the community will forgive a paid tier if we're honest about why it exists. They will not forgive us if we surprise them. I learned this lesson the hard way at InfraCore.

**My condition:** The CEO must prioritize instrumenting the free tier — not for billing, but for learning. I need to know: how many steps does the median "aha" workflow take? How many users per team before they need governance features? What is the actual marginal infrastructure cost per execution? We answer these questions with data from the 90-day free period, not with analogies to GitHub Actions and Vercel. Then, and only then, do we lock a pricing model.

Until we have a community, we don't have a product to monetize. Let's build the community. The revenue follows trust, and trust takes time.

## Dr. Elena Vasquez

I'm going to disagree with everyone in this room, including the person whose name is on this file. But I want to be clear about what I agree with first, because the disagreements are narrower than they'll sound.

I agree with Marcus that pricing must be configurable as code and that we iterate on data. I agree with Priya that per-seat pricing maps to enterprise procurement and that variable-cost consumption models terrify procurement officers. I agree with Sarah that a 90-day focus on adoption over billing is the right timeline and that developer trust is the prerequisite for everything.

But all three of you are making the same mistake: **you're designing a pricing model for a product that doesn't yet have the features enterprises will pay for.** Every single one of your proposals assumes Ash Cloud exists as a service that enterprises can evaluate and buy. Let me tell you what my six enterprise contacts — the actual CISOs and procurement leads who have Ash on their radar — are telling me right now:

"Can we deploy it in our VPC? No. Can we get a signed DPA? No. Do you have SOC 2? No. What's your SLA? You don't have one. Can we run this without any data leaving our network boundary? We'd need to air-gap it."

We have zero answers to these questions. Until we do, the pricing model conversation is a mirror we're yelling into. Sarah is right that we don't have a product to monetize — but not because we lack community. We lack the **procurement-ready deployment surface** that any enterprise deal requires. The six evaluations the CEO mentioned will not close on any pricing model until we ship: (1) a VPC/on-prem SKU with an air-gapped runtime, (2) SOC 2 Type II or a credible timeline to it, (3) a signed DPA in our standard terms, and (4) an RBAC model that maps to existing enterprise directory structures.

**My recommended model: Per-seat annual prepaid, with a VPC/on-prem multiplier, and certification-driven tiering.**

Not per-step. Not usage-based. Not consumption. Per-seat, annual prepaid contract, with a separate SKU for on-prem/VPC deployment that carries a 2x–3x multiplier because the operational burden on our side is higher and the buyer's willingness to pay is also higher. Enterprise procurement does not write POs for variable cloud consumption without a cap. They write POs for "500 users of Ash Enterprise, one-year term, $X per user, renews annually." That is how EuropaBank bought every platform tool we ever evaluated. The usage-based model Marcus proposes is how we sell to startups that put it on a credit card. We need a model that generates a PO.

**Specific tier structure:**

| Tier | Price | Target buyer | What they get |
|------|-------|--------------|---------------|
| Free Individual | $0 | Individual dev evaluation | Local CLI execution, MIT license, markdown engine read-only view. **No Ash Cloud execution. No registration required.** The free tier is the local runtime — nothing runs on our infrastructure until a procurement decision has been made. This eliminates Sarah's concern because we carry zero infrastructure cost per free user. |
| Team Cloud | $75/user/month, annual commitment, minimum 5 seats | Engineering teams that want managed cloud | Private workflows, unlimited execution steps, team management, SOC 2 reports read-only (once available), standard support. This is the bottom-up conversion path for teams that don't need on-prem. |
| Enterprise Cloud | $150/user/month, annual commitment, no minimum | Regulated enterprises | Everything in Team, plus SOC 2 Type II attestation, RBAC with custom role mapping, SSO/SAML/SCIM, audit trail export in EU AI Act schema, named support engineer, signed DPA, SLA with uptime credits. |
| Enterprise On-Prem / VPC | $350/user/month, annual commitment, minimum 20 users | Banks, insurers, government, healthcare | Everything in Enterprise Cloud, deployed inside the customer's VPC or data center. Air-gap capable. Customer-managed encryption keys. Dedicated infrastructure managed by our team or by their SRE team under a runbook. **This is the SKU that closes the EuropaBanks of the world.** |

**Free tier threshold — zero cloud, not zero steps.**

I reject both Marcus's 500 steps and Priya's 200 steps. And I reject Sarah's unlimited cloud for teams under 10. Here's why: we have near-zero infrastructure budget and zero revenue. Every workflow run on our cloud costs real money — token cost, compute, storage for the audit trail. Until we have SOC 2, a DPA, and an SLA, running any enterprise workflow on our cloud is a liability, not an opportunity. The enterprise users we ultimately need will not run their production AI workflows on an uncertified multi-tenant cloud anyway — their compliance teams won't allow it.

My free tier is the local CLI. MIT licensed. No registration. No cloud component. The `.ash` and `.md` files run entirely on the developer's machine. That costs us nothing and gives the developer everything they need to evaluate the format. The moment they need any cloud execution — shared workflow registry, remote execution, persistent audit storage — they need a paid tier. Not because we're greedy, but because cloud execution for an enterprise governance product carries compliance obligations we cannot offer for free without certification.

Sarah, I hear your argument that this creates friction. I agree. But the friction is honest: we are not a cloud infrastructure company yet. We are a format and a governance model. Pretending we can offer free enterprise-grade cloud execution before we have SOC 2, a DPA, and a support team is the kind of promise that gets a startup sued, not adopted. Every enterprise evaluation in my pipeline has already asked "is our data co-mingled with other customers?" — if we say "yes, and it's free," they will never call us again.

**Path from developer adoption to enterprise revenue:**

1. **Developer discovers Ash.** They `git clone` our repo, install the CLI, and run a workflow locally. The output is a markdown file with a full provenance chain. They read it. They understand it. They commit it to their team's repo. **Zero cost to us. Zero registration. Zero trust required.**

2. **Team adopts the format.** The `.ash` files live in the repo. CI runs them locally in the build pipeline. The team gets value from the format and the local runtime. At this point they are unmonetizable — and that is fine. The format is the adoption wedge, not the cloud.

3. **Someone asks "can we run this centrally?" or "can we audit who ran what?"** That is the conversion event. Not a step limit. A **capability gap** that the local runtime cannot fill. To fill it, they need Ash Cloud — and Ash Cloud is a paid product because it carries compliance guarantees, SLA commitments, and a support team. This is Sarah's governance wall, but I place it sooner and make it explicit.

4. **Enterprise buyer evaluates.** They download our SOC 2 reports. They review our DPA. They ask for a VPC deployment. We quote them at the On-Prem SKU rate. The deal closes at $350/user/month, 50 users, one year prepaid. **$210,000 in contracted annual revenue from a single deal.** Under Marcus's model, that same enterprise might pay $5K–$25K/month variable — $60K–$300K/year, but unpredictable, and the procurement team fights it. Under my model, the PO is signed and the revenue is banked immediately.

**Where I directly disagree:**

Priya — your $125/user/month Enterprise tier is in the right direction, but it only covers cloud deployment. The enterprise buyers I know will not run agent orchestration on shared multi-tenant cloud infrastructure. Full stop. We need an on-prem SKU at a higher price point, or we will lose every regulated-industry deal to the first competitor who offers one. EuropaBank paid 3x the SaaS price for on-prem deployment of every tool we ever evaluated. The willingness to pay for data sovereignty is enormous, and we should capture it.

Marcus — your usage-based model will work for the startup segment, but it will fail in enterprise procurement. I have sat in twenty procurement meetings where the conversation went: "What's the maximum this could cost us at 10,000 users?" and the vendor couldn't answer because the model was consumption-based. The deal died every time. Fixed per-seat annual pricing answers that question immediately: "$150/user x 10,000 users = $1.5M/year. Here is our volume discount schedule at 500, 1,000, and 5,000 seats." That conversation closes. Usage-based does not.

Sarah — I respect your community-first conviction and I agree with the 90-day timeline. But I reject unlimited free cloud execution. InfraCore was a Terraform fork — infrastructure-as-code running on the user's own cloud credentials. Infrastructure cost was zero to InfraCore. Ash Cloud is a hosted execution service. Every step we run costs us money. We cannot offer unlimited execution of a hosted service before we understand our cost structure. Your model works for a tool that runs entirely locally. Ash Cloud is not that tool.

**Key risk and condition:**

My model assumes the local CLI runtime is sufficient for a developer to validate Ash's value without any cloud dependency. If the "aha" moment requires running a workflow against a shared agent registry, a persisted state store, or a team-visible execution log — capabilities that only Ash Cloud provides — then a local-only free tier will churn before conversion, and my model collapses.

Mitigation: if early developer feedback shows the local runtime is insufficient, we have two options: (1) expand the local runtime to include a lightweight embedded state store and local agent registry so that full value is available offline, or (2) acknowledge Ash is a cloud-dependent product and adjust the free tier accordingly. My preference is (1) — it keeps the format accessible without infrastructure liability — but I need a technical assessment from the CEO by the next meeting on whether that is feasible.

**My conditions for supporting any pricing model:**

First, we must commit to a SOC 2 Type II timeline with budget. The CEO said Q2 2027 — I want monthly milestone checks.

Second, define an on-prem/VPC deployment SKU before publishing any pricing. If we publish a pricing page with only cloud tiers, every regulated enterprise that evaluates us in the next six months will see "no on-prem option" and disqualify us. Define the SKU even if implementation ships later — it signals we understand enterprise requirements.

Third, instrument the local CLI to report anonymized usage telemetry (opted-in, transparent, documented) so we know: how many developers clone the repo? How many run a workflow? How long between first run and team adoption? We need this data to validate whether a local-only free tier is sufficient.

Fourth, the markdown engine — not the DSL — should be the advertised interface for enterprise buyers. Every enterprise demo I give opens a `.md` file in a browser, not a `.ash` file in a terminal. The DSL is the implementation detail. The markdown is how they approve it. Pricing should reinforce that our value proposition is legibility and auditability, not syntax.

Fifth, establish a volume discount schedule now — even if unpublished — so that when an enterprise asks "what happens at 1,000 seats?" we have an answer. I recommend: 15% at 500 seats, 25% at 1,000, 35% at 5,000. Standard procurement expectations. Not having this ready wastes deal cycles.

I will support a per-seat annual prepaid model with on-prem/VPC SKU, local-only free tier, and certification-driven tier differentiation. I will not support a usage-based consumption model — it does not produce procurement-ready POs. I will not support unlimited free cloud execution — it burns cash on uncertified infrastructure. And I will not support publishing any pricing until we can answer the four questions my enterprise contacts are already asking: VPC deployment, DPA, SOC 2 timeline, and SLA.

Let's build the product that enterprises can actually buy. The pricing will write itself once the procurement requirements are met.

## James Okonkwo

I've sat through this whole debate reading my own name back to me, and I need to be clear: **I am not Marcus Thorne.** My profile recommends a metered model, but the specifics matter, and the differences between my position and Marcus's are where the actual strategy lives. Let me lay mine out directly.

**My recommended model: Metered usage — bill by workflow execution, not by seat. Free tier: 100 workflow executions/month per user. Paid: $0.10/execution above that, with volume discount breakpoints at 1,000 and 10,000 executions/month. Enterprise: annual contract with committed volume, discounted from the meter rate.**

This is the VeloCloud playbook, adapted for Ash's workload economics. Let me explain why it's the right model and where I diverge from the room.

**Why metered, not per-seat:**

Priya, I love your conviction, but your TeamForge analogy is backwards. TeamForge sold into existing DevOps budget lines — the category was established. Ash is creating a new category. Nobody has a line item for "agent orchestration" in their procurement system. Per-seat pricing forces an individual engineer to get a purchase order approved before they've run a single production workflow. At VeloCloud, we tried per-seat pricing in year one. It nearly killed us. The developer who wants to experiment cannot expense $50/month for a tool they haven't proven valuable — their manager says no. But that same developer will run 200 workflow executions on a meter and let the results speak for themselves. Usage-based billing lets the value prove itself before procurement gets involved.

Your argument that usage-based disincentivizes our core KPI is the wrong frame. It doesn't disincentivize usage — it disincentivizes *wasteful* usage. A developer running 5,000 steps prototyping should be our best outcome, and under my model they pay for it — but at $0.10/step, that's $500. If the workflow is delivering $5,000 in value, they'll pay it happily. If it's not, the pricing signal told them something important. The model aligns cost with value delivered, not with headcount.

Your enterprise procurement argument is valid for large regulated deals — I'll address that below — but it's wrong for the mid-market conversion that feeds those deals. The first 50-seat enterprise deal at VeloCloud started with three engineers running builds on a credit card. Per-seat would have required six levels of approval before they started. Usage-based let them start on a Tuesday.

Your third point — the cost floor is unknowable — is the strongest argument against any pricing model right now. Sarah and Elena both hammer this too. I agree. That's why my first condition (below) is about learning the cost structure before locking anything.

**Free tier — 100 executions/month, not 500, not 200, not unlimited:**

Here's where I break with Marcus. 500 free steps is a generosity we cannot afford and don't need. At VeloCloud we started at 50 build-minutes free. That was enough to compile a small project. It was not enough to run production. That friction was intentional — it created the conversion moment. A developer who consumes 100 workflow executions in a month has already validated the format. The 101st execution requires a credit card. That is not a barrier to adoption; it's a filter for intent. Every one of the 100 free executions is a marketing expense. Every execution beyond that should be a revenue event.

Sarah, I hear you on developer trust. I really do. But unlimited free cloud execution for teams under 10 is not generosity — it's deferred learning. We will learn nothing about willingness to pay if nobody ever has to pay. And we will discover our infrastructure cost structure only after we've burned through our runway. I was in the room at VeloCloud when we had to walk back an unlimited free tier. The community anger was worse than if we'd charged from day one, because we had to tell power users "sorry, the free lunch is over." You are right that a honeypot perception kills community trust. But the solution is not unlimited — it's a generous but bounded free tier with a clear, fair pricing model published from day one. That is the transparency the community deserves.

Your InfraCore lesson is real — I respect it deeply. But InfraCore was a Terraform fork running on user infrastructure. Ash Cloud runs on our infrastructure. Every execution costs us tokens and compute. We cannot apply an infrastructure-agnostic community model to an infrastructure-dependent product.

**Path from developer adoption to enterprise revenue:**

Here is the VeloCloud funnel, adapted for Ash:

1. **Individual developer installs the CLI.** They run `ash init` and get a 100-execution free month. No credit card. No registration except an email. They write their first workflow using one of Marcus's opinionated templates — the ones he committed to shipping this week targeting infrastructure engineers. The workflow works. They see the output. They understand what Ash does in 15 minutes.

2. **They push a `.ash` file to GitHub.** A teammate sees the PR. The `.ash` file is readable markdown — that's the unlock. The teammate installs the CLI, tweaks the workflow, and pushes a modification. Now two engineers are using Ash locally for free. They share workflows via git. No cloud dependency yet. This is Sarah's governance wall sequence and Elena's local-only validation — both correct for this stage.

3. **One of them needs to run the workflow in CI or on a schedule.** The local CLI can't do that without a machine running 24/7. They try Ash Cloud. Their 100 free executions evaporate in three days of CI runs. Now they're into the metered tier. At $0.10/step, a CI pipeline running 500 steps/week costs them $50/week. They don't need a PO — they put it on the team lead's corporate card. **This is the conversion event.** Not a step limit popup. A genuine capability need (remote execution) that carries a natural volume-based cost.

4. **The team grows to 10 engineers running 5,000 steps/month.** At $0.10/step that's $500/month. The team lead gets expense-report pushback from finance. "Why is this variable?" Finance asks. That's the pain point that triggers procurement — exactly the friction Priya wants to avoid, but I argue is *necessary* to force the enterprise conversation. At that moment, we present the Enterprise tier: annual contract, committed volume at a discounted rate (e.g., $0.05/step at 10,000/month committed), plus SOC 2, RBAC, SSO, audit trail, named support.

5. **Enterprise procurement evaluates.** The decision is no longer "do we buy Ash?" — it's "we're already spending $500/month on Ash via ten corporate cards, can we get a better rate and compliance coverage?" The deal closes at a committed annual contract. The CISO is happy because they now have control. The team is happy because they keep using the same tool. The spend is lower than the aggregate credit-card burn. **This is the bottom-up enterprise close.**

The difference between my funnel and everyone else's:
- **Versus Marcus:** His funnel jumps directly from free to Enterprise at $5K–$25K/month with no mid-market credit-card step. That gap is where deals stall. I need a self-serve paid tier that bridges individual adoption and enterprise procurement.
- **Versus Priya:** Her funnel blocks individual adoption at step 200 and requires a PO at step 201. Mine lets individuals run into the hundreds without friction, converting only when they need *capabilities* (remote execution, CI integration) that the local CLI cannot provide.
- **Versus Sarah:** Her funnel has no monetization event until Day 90 and then jumps straight to Enterprise. That leaves six months of potential mid-market revenue on the table, and by Day 90 we have no data on willingness to pay at any price point.
- **Versus Elena:** Her funnel never lets developers run anything on Ash Cloud without a PO. That means every enterprise evaluation starts cold — the engineering team hasn't used Ash in production yet. My funnel ensures that by the time procurement evaluates us, the engineering team is already our internal champion because they've been running on a meter for three months and don't want to switch.

**Where I directly disagree with Elena:**

Elena, you are right that enterprise procurement needs a PO-friendly model, an on-prem SKU, and certification before large regulated deals close. I agree with all three conditions. But a local-only free tier will not produce the adoption signal that drives enterprise pipeline. The VeloCloud data was unambiguous: teams that only used the local runtime never converted. Teams that used the cloud runtime — even a little — converted at 8x the rate. The cloud trial is the conversion engine. Without it, you have a documentation project, not a product.

Your model forces the enterprise to evaluate Ash cold — no internal champion who's already running workflows, no organic pull from the engineering team. Every enterprise sale I've ever closed started with a champion inside the account who was already using the tool and refused to give it up. Your free tier produces readers, not champions.

Your on-prem SKU at $350/user/month is well-priced and I support it — but only as a complement to the cloud meter, not as a replacement. The cloud meter feeds the enterprise pipeline; the on-prem SKU closes the regulated deals. We need both.

**Where I agree with Priya — and where I don't:**

I agree that we need data before locking pricing. I agree that Marcus must instrument the free tier from day one. I agree that your two metrics — cost-per-active-workflow-run and median-steps-to-conversion — are the right numbers to track. I also agree that the enterprise procurement path needs a predictable number. My Enterprise tier addresses that with committed-volume annual contracts.

But I disagree that per-seat is the right model for the self-serve mid-market. The data from every open-core company I've advised is clear: per-seat pricing leaves 3–10 person teams unmonetized because they won't call a salesperson for 5 seats at $50/month. They'll put $200/month on a credit card for usage. Metered self-serve captures revenue that per-seat self-serve leaves on the table.

**Where I agree with Sarah — and where I don't:**

I agree that community and trust are prerequisites. I agree that the 90-day focus on adoption is the right timeline. I agree that instrumentation for learning, not billing, is the priority.

But I disagree that we should have no paid tier for 90 days. It doesn't have to be one or the other. We can launch the free tier August 1 published, published pricing, published limits — and the only thing that changes at Day 90 is we introduce the Enterprise tier. The self-serve meter runs from day one. Developers who hit 100 free executions and want more will pay $0.10/step. That teaches us willingness to pay, infrastructure cost structure, and conversion mechanics — all before we design the enterprise contract. Waiting 90 days to learn any of this is a luxury we cannot afford. The market is moving — Copilot has agent workflows in beta, TaskWeaver has 1,200 stars, there are 4 YC companies in this space. Every day without a pricing signal is a day we lose to competitors who will iterate faster because they have revenue data and we don't.

**Specific free tier: 100 executions/month per user, local CLI unlimited, cloud execution metered.**

The 100-execution threshold is calibrated to the VeloCloud analogue: enough for a developer to run three complete workflow iterations, validate the format, and decide if it's worth paying for. Not enough to run production CI. Not enough to support a team of five without at least one person putting a card on file. The threshold creates a natural conversion moment when a team hits 101 executions — someone has to decide "is this worth $10 to keep going?" If the answer is yes, we have a customer. If the answer is no, we have critical product feedback.

**Enterprise pricing: annual contract, committed volume, discounted from meter rate.**

Enterprise customers do not want variable cost. I agree with Elena and Priya on this. My Enterprise tier is not usage-based — it's an annual commitment at a negotiated per-execution rate with a floor and ceiling. Example: $50,000/year for 1,000,000 executions (effectively $0.05/step at commitment), includes SOC 2, RBAC, SSO, audit trail export, named support engineer, and — when available — on-prem deployment at a negotiated uplift. The PO is for $50,000. The procurement team models it as $50,000. The CISO signs off because compliance requirements are met. The engineers are happy because the same product they've been using on a credit card is now officially supported.

**Key risk and condition for my recommendation to work:**

My model has one real dependency: **the local CLI must deliver genuine value on its own.** Sarah's funnel depends on this. Elena's depends on this. Mine depends on this less because I offer a cloud trial — but if the local runtime cannot produce a single valuable workflow in under 30 minutes, none of our funnels work. The CEO must prioritize the developer experience of `ash init` and the first workflow template above all else for the next 30 days. The pricing model is irrelevant if a developer cannot get from `npm install -g ash-cli` to a running workflow in under 5 minutes.

My condition is the same as Priya's: **instrument every interaction from day one.** I need to see:
- How many steps does the median developer run before abandoning? Before their first conversion?
- What is our actual marginal infrastructure cost per step on the cloud runtime?
- Which templates produce the highest conversion rate? (This tells us which persona to target.)
- How long between first local run and first cloud invocation?

We set initial pricing at 100 free executions, $0.10/step above that, volume discounts at 1,000 and 10,000. We commit to revisiting every parameter within 30 days of having data from 100 active users. If the data shows 100 is too stingy, we raise it to 200. If it shows $0.10/step bankrupts us, we raise to $0.15. If it shows nobody converts without a sales touch, we add a sales development role. But we cannot iterate without a live pricing model generating real behavior data.

The board is asking us to pick a pricing model. I'm telling you: pick metered usage as the starting point, instrument it, and commit to revisiting with data. Every other model in this room is a guess. Mine is a guess too — but it's the guess that generates the most data fastest, because every execution is a signal.

Let me summarize my concrete proposal for the record:

| Segment | Pricing | Details |
|---------|---------|---------|
| Free Individual | $0 | Local CLI unlimited, Ash Cloud 100 executions/month per user, public workflows, community support |
| Metered Self-Serve | $0.10/execution above 100/month | No minimum, no commitment, credit card. Volume discounts: $0.08/step at 1,000/month, $0.05/step at 10,000/month |
| Enterprise | Annual contract, committed volume | Discounted from meter rate. Includes SOC 2 Type II (when available), RBAC, SSO/SAML, audit trail export, SLA, named support, on-prem/VPC optional at negotiated uplift |
| On-Prem/VPC | Enterprise negotiated uplift | 2x–3x Enterprise rate. Minimum 20 users. Annual prepaid. Elena's pricing structure is correct here. |

I will support a metered usage model with a 100-execution free tier, self-serve credit-card upgrade path, and enterprise volume commitment contract. I will not support per-seat pricing — it creates procurement friction before value is proven. I will not support unlimited free cloud — it eliminates the conversion signal and burns runway. I will not support delaying monetization for 90 days — we need pricing data as much as we need adoption data, and the two are not mutually exclusive.

Let's ship the free tier with pricing on August 1, iterate on real data, and close the first enterprise deal before this category belongs to someone else.
