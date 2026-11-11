# Discussion — Licensing

## Marcus Thorne

I wrote the first `.ash` parser in a weekend because I wanted AI workflows to live in files I could `git diff`, not in chat threads I couldn't audit. I picked MIT the same way — not because I studied the options, but because MIT was what every tool I admired used. It was the default. I never questioned it. I'm questioning it now.

Let me be direct about why I'm shaken: GitHub Copilot is shipping agent workflows. TaskWeaver has 1,200 stars with a near-identical format. Four YC companies are in this space. The fear that a big platform player bundles "good enough" orchestration into an existing product and commoditizes our format before it becomes a standard — that fear is real and it lives in my head every day. A defensive license (BSL, SSPL, FSL, call it what you want) promises to prevent that capture. Keep the code close enough that no one can take it and compete.

I've thought about this for the past six weeks. I've read the HashiCorp BSL postmortems. I've watched what happened when MongoDB went SSPL. I've looked at every director in this room knowing they've navigated versions of this decision. And here's where I land:

**Recommendation: Stay MIT.**

Not because I'm emotionally attached to open-source purity — though I am, and Priya would tell you that's my bias. But because for Ash at this moment — zero users, zero revenue, zero community — a defensive license is existential risk, not protection. Here's why.

**1. Adoption is the only problem that matters at zero.**

The inputs document says it plainly: 0 npm downloads, 0 GitHub stars, 0 active workflows. We are not at risk of competitive capture. We are at risk of irrelevance. MIT is the lowest-friction signal we can send: "Use this. Modify it. Ship it. Build on it. We will not sue you." Every defensive license in the market carries a trust cost — the developer reads "BSL" and thinks "this is open source until they change their mind." That trust cost compounds when you have zero community equity to offset it. TaskWeaver uses MIT. If we go BSL while they stay MIT, they get the "truly open" label and we get the "toll booth" label. That is a losing position at zero adoption.

**2. The moat isn't the parser. The moat is the format.**

I wrote the parser in a weekend. The code is not the defensible asset — the `.ash` convention, the workflow registry, the governance layer, the cloud execution platform, the community conventions — those are the defenses. MIT means the parser spreads everywhere. Every fork, every repackaging, every copy-paste into a monorepo is adoption of the `.ash` format. That is the network effect we need. A defensive license tries to protect code value. Our value is in the standard becoming ubiquitous. Those two strategies are in direct tension.

**3. Open standard requires open license — this is not negotiable.**

The mission says: "Open source, open format, open governance." Pillar 1. I wrote those words. You cannot credibly claim to be an open standard while using a license that restricts implementation, redistribution, or competitive use. BSL is not an open-source license by the OSI definition. SSPL is not. FSL is not. If we want Ash to be "the default way organizations describe how AI agents should work together," we cannot require permission to implement that description. An open standard you need a license to use is not an open standard.

**4. The biggest risk of staying MIT — and I want this on the record.**

A platform player — GitHub, JetBrains, whoever owns the editor — adopts `.ash` natively, builds it into their product, and captures the network effect we need for Ash Cloud. Developers never visit ash-lang.com. They never see the governance tier. They run workflows inside their IDE and never hit the conversion moment. The format succeeds. We don't.

This is the risk that keeps me up at night. It is real. A defensive license prevents it. So why am I not choosing that?

Because the defensive license does not prevent a platform player from building a *compatible* format from scratch. If Copilot ships a YAML task file today (which they did — it's in the inputs), BSL doesn't stop them from shipping a `.ash`-compatible parser written independently. The defensive license only prevents them from copying our code — and our code is the easiest part to rewrite. The real defensibility is the community, the convention, the registry of workflows, the governance layer, the fact that your entire organization has `.ash` files in every repo. A defensive license doesn't build those things. Adoption builds those things. And MIT is the fastest path to adoption.

**5. What else must be true for MIT to work.**

I am not recommending MIT out of ideology. I'm recommending it with conditions — commitments I'm making to this board:

- **Ash Cloud must be the best place to run an `.ash` workflow.** Not the only place. The best place. Speed, reliability, workflow registry, one-command deployment, cross-agent execution that's painful to replicate locally. If the cloud runtime is not meaningfully better than `ash run` on a laptop, we have no conversion path and MIT gives away everything for nothing. I'm committing to making Ash Cloud the best runtime.

- **Governance is the enterprise moat.** SOC 2 Type II, EU AI Act audit schema, RBAC, SSO, deterministic execution, full provenance chain — these are the features a platform player cannot bundle into an IDE for free. Elena is right: enterprise buyers will not deploy agent orchestration without these. MIT gives away the format. Governance sells the premium. These are not in tension. I'm committing to the Q2 2027 SOC 2 timeline I stated today, not as a compliance checkbox but as our primary enterprise defensibility.

- **We must win format adoption before the platform players commoditize it.** This is the race. MIT optimizes for speed. We need 100 active developers, 10 teams shipping workflows, 1 enterprise evaluation — then 10x that — before the category definition belongs to someone else. I committed to shipping three opinionated workflow templates targeting infrastructure engineers — the persona TaskWeaver is ignoring — by July 17. I'm doubling down on that: every week one more template, one more community touchpoint, one more reason to write `.ash` instead of `.yaml` or `.json`.

- **We reevaluate at a milestone, not a date.** If we hit 1,000 active developers publishing workflows and platform capture is accelerating, I'll call this board to revisit the license. But we cannot make that call at zero. We need data. We need leverage. MIT gets us to the data.

**Summary for the record:**

I recommend staying MIT. The defensive license protects code we can afford to give away and costs trust we cannot afford to lose. The biggest risk (platform commoditization) is real but not solved by a license change — it's solved by building a cloud governance layer that is meaningfully better than any bundled alternative. My conditions: Ash Cloud must be the premium runtime, governance must be the enterprise moat, we must race to format adoption, and we revisit the license decision when we have actual adoption data and market leverage, not before.

I have the scar tissue from scaling infrastructure at MerchantOS. I know the difference between a real moat and a legal one. A defensive license today is a comfort blanket, not a strategy. MIT is the hard path — it forces us to build things people will pay for, not things we can sue over. That's the path I'm taking.

## Priya Nair

I'm going to start with a premise that may sound harsh but I mean it as a service to this board: this entire conversation is a trap. It is a symptom of exactly one problem — product insecurity masquerading as strategic deliberation — and every minute we spend on it is a minute we are not solving the only thing that matters at this company.

Marcus has already made an excellent case for staying MIT, and I agree with most of it. But where he argued from principle and mission, I'm going to argue from spreadsheets, portfolio pattern-matching, and the cold math of capital allocation. Because I've watched three companies in the Orchestra portfolio get seduced by this exact conversation, and all three regretted it. Two of them are dead.

**My recommendation: Stay MIT. Unequivocally. And do not revisit this for at least 12 months or 1,000 active developers — whichever comes first.**

Here is the logic.

**1. The license does not solve your actual threat model.**

Let's name the real threats in order of probability:

- **Threat A (95% probability):** Ash never achieves product-market fit and dies quietly. Zero adoption remains zero. We never get to the point where competitive capture matters.
- **Threat B (4% probability):** TaskWeaver or some other startup wins the category because they out-executed us on community, templates, onboarding, and developer experience — not because they had a different license.
- **Threat C (1% probability):** A platform player like GitHub or JetBrains adopts the `.ash` format wholesale, builds a compatible runtime into their product, and captures the network effect so Ash Cloud never converts.

A defensive license addresses Threat C at best — and even then, imperfectly, because as Marcus correctly noted, a platform player can independently implement the format without ever touching our code. Copyright protection on a 500-line parser written in a weekend does not stop a company with 5,000 engineers.

Meanwhile, a defensive license *actively worsens* your odds against Threat A and Threat B. BSL, SSPL, FSL — each one adds a question to the developer's evaluation: "Is this actually open source? Will they change the terms? Do I want to build my infrastructure on someone else's tolerance?" At zero adoption, you cannot afford that question. TaskWeaver's first line on their README: "MIT licensed." We cannot let them own that word.

The expected value calculation here is damning. You are paying a certain cost (trust friction, community confusion, talent pipeline friction) for an uncertain and partial defense against the least probable threat. This is not a good bet.

**2. This is an opportunity cost problem, not a licensing problem.**

Let me read from the board inputs: $0 revenue. $100 token cost. Zero npm downloads. Zero GitHub stars. Zero forks. Zero active workflows.

And we are debating which license to use.

I want to be blunt: the license has zero impact on any of the problems that will determine whether this company exists in 18 months. Our burn is near-zero because Marcus is the only employee — good. But every hour he spends reading HashiCorp BSL postmortems or comparing SSPL vs. FSL language is an hour he is not shipping templates, not writing onboarding docs, not fixing the testing gap that the inputs document explicitly names as a bottleneck, and not figuring out why TaskWeaver hit 1,200 stars while we are at zero.

The opportunity cost of this conversation is not zero. It is the work product of the only person who can build this product. That is an expensive conversation.

When I look at my portfolio companies that tried to use a license as a moat, the pattern is consistent: they were avoiding a harder problem. The BSL discussion was a displacement activity — something to debate that felt strategic but was actually just procrastination on the uncomfortable work of talking to users and iterating on product. I am not going to let that happen here.

**3. The biggest risk of MIT — and this is where I differ from Marcus's framing.**

Marcus identified platform commoditization as the risk of MIT. I think the real risk is different: it's that we stay MIT but also stay *slow*. MIT is the right call only if we pair it with real velocity. If we stay MIT and do nothing else differently — same pace, same output, same zero-adoption trajectory — then MIT was a wasted gesture. The risk isn't that a platform player takes our code; it's that we give away the code for free and still don't win.

In other words: MIT is necessary but not sufficient. It removes a friction point, but friction is not our problem. Our problem is that no one has ever heard of us or felt the pain this solves.

**4. What must be true for my position to work.**

I am voting for MIT — but I am attaching conditions that apply to Marcus and to the entire board:

- **We stop talking about licensing.** Permanently, until the milestones Marcus set (100 active developers, 10 teams, 1 enterprise evaluation) are met. I want this minuted. If I see another slide deck with a licensing comparison in it before we have 100 active developers, I will call a separate board meeting to discuss why we are wasting the company's only engineering resource on legal theory.

- **We optimize every decision for adoption velocity, not protection.** That means: more templates, more community touchpoints, more on-ramps. It means Sarah's instinct to keep free tiers generous is right. It means the pricing model we settled on today with 500 free steps is the right direction even though I voted against usage-based pricing — because the more important vector right now is getting workflows into the wild, not optimizing the billing model.

- **We recognize that the real defensibility — the enterprise governance layer, the workflow registry, the audit trail, the compliance infrastructure — is what we need to spend our engineering time on, not license strategy.** Elena's questions about SOC 2 and EU AI Act are the right questions. That is where the moat lives. That is what a platform player cannot clone in a quarter.

- **We need to grow fast enough that the license conversation becomes irrelevant.** The only world where MIT is the wrong answer is the world where Ash has meaningful adoption but loses the monetization path to a platform player — and that world is 18 months away at best. If we arrive in that world, we'll have adoption data, enterprise relationships, and leverage to make a different call. We don't have any of those things now.

**Summary for the record:**

MIT. Not because of open-source idealism — I am an investor, not an activist. MIT because it is the lowest-friction, lowest-trust-cost, highest-adoption-velocity option available, and adoption velocity is the only metric that determines whether this company survives. A defensive license is a solution in search of a problem we do not have, and it carries real downside against the problems we do have (zero adoption, zero awareness, zero distribution).

The license conversation is a trap. Walk away from it. Go build the thing people will pay for.

## James Okonkwo

I walked into this room planning to say one thing: MIT, next question. Then I heard three hours of debate about defensive licenses from people I respect — and the only thing that changed my mind is that I need to argue this harder, not differently. So let me bring the GTM lens, because that's what I'm here for.

Marcus, your argument from mission is right. Priya, your argument from portfolio math is right. Elena, your argument from procurement reality is right. I agree with all three of you, and my job today is to add something I don't think any of you can: the scars of selling a product built on MIT to 800+ enterprise customers and watching the license never once come up as a reason we won a deal or lost one.

**My recommendation: MIT. Emphatically. And I want us to stop treating this as a decision we can revisit later without consequences.**

Here's my reasoning.

**1. I've lived the "MIT is a liability" fear — and it was wrong.**

At VeloCloud, NextGen.js was MIT. We had the exact same conversation in 2019: "What if AWS bundles a compatible runtime? What if our format gets commoditized?" The legal team drafted a BSL proposal. I killed it. Here's what actually happened: Amazon did ship a compatible service. It was worse than ours. Customers who tried it came back because the workflow lock-in was to the *format* — and our cloud runtime was faster, more reliable, and had the governance features enterprise buyers required. The format adoption we got from MIT was the reason we had an installed base to upsell. Without MIT, we never get the installed base. The license didn't protect us. The product did.

Priya's threat model is the right way to think about this. I'd even adjust her probabilities: Threat A (never achieve PMF) is 97%, Threat B (out-executed by startup) is 2.5%, Threat C (platform capture) is 0.5%. A defensive license optimizes for the 0.5% at the direct expense of the 99.5%. That math does not work.

**2. The trust cost is not theoretical — I've seen it kill deals.**

When I ran sales at TeamForge, we had a competitor who used a non-OSI license. Their product was better. Their price was lower. And they lost every single enterprise deal to us for one reason: procurement said no. Not "let us evaluate" — no. Elena described the gate perfectly. But let me add a dimension from the seller's side: the competitor's sales reps spent 40% of their deal cycle in legal review conversations. My reps spent 0%. That 40% difference is fatal in a quarter-end sales motion where velocity is everything.

The license cost shows up in places the engineering team never sees: extended sales cycles, legal objection training for reps, procurement roadblocks that kill deals in week 8 of a 12-week quarter. MIT eliminates an entire objection category. At zero revenue, we cannot afford the sales cycle drag of a non-standard license — and we cannot afford to train reps who don't exist yet on how to handle the "your license scares our legal team" call.

**3. The biggest risk of MIT — and the difference between me and Priya on this.**

Priya says the risk of MIT is staying slow. I agree but I'd frame it differently: the risk is that we treat MIT as a *sufficient* strategy rather than a *necessary* one. MIT gets you in the door. It does not close the deal.

The real risk is that Ash Cloud never becomes meaningfully better than `ash run` on a laptop. If the cloud runtime is a thin wrapper around the open-source CLI, then MIT gave away everything and we captured nothing. The conversion mechanism — the thing that turns an MIT user into a paying customer — must be the governed execution environment that enterprises cannot replicate internally. That is what I mean when I say "Ash Cloud must be the best place to run an `.ash` workflow." Not cheaper. Not friendlier. *Governed*.

I want to be more specific than the meeting minutes capture. What "best place to run" means to an enterprise:

- **Deterministic replay:** Every workflow execution produces a cryptographic trace that can be verified independently. The open-source CLI does not do this. Ash Cloud does.
- **Policy-as-code:** RBAC rules, approval gates, and compliance checks that are enforced at runtime, not in a `README`. The open-source runtime has no policy engine. Ash Cloud does.
- **Procurement artifact:** A SOC 2 Type II report, a signed DPA, a penetration test summary, and a data processing exhibit that legal can file without redlining. The open-source project cannot produce any of these. Ash Cloud does.

These are the conversion mechanics. MIT gives away the parser so enterprises can evaluate the format in a sandbox. Ash Cloud closes the deal because the sandbox is not production-ready. This is the VeloCloud playbook — and it works.

**4. What else must be true for MIT to work.**

I'm voting for MIT. But I need four commitments from this board — and if we cannot agree to these, then MIT is a cargo-cult strategy and I will formally dissent:

- **We define "cloud value" in concrete terms by next meeting.** Not "best runtime" — that's marketing. I need: which three features exist only in Ash Cloud, which enterprise personas they appeal to, and what the conversion metric is (e.g., "70% of teams that use Ash Cloud for 30 days upgrade to paid"). Without these definitions, we cannot build the conversion mechanism and MIT is just giving away code for charity.

- **We instrument every user touchpoint from day zero.** The inputs document says we shipped npm and VS Code with zero telemetry. That is a crisis. I cannot optimize the adoption funnel if I cannot see it. Marcus, I need user-authorized telemetry in the CLI and VS Code extension shipped within two weeks — adoption events, workflow execution counts, error rates, conversion points. No data, no GTM.

- **We accept that the license conversation is closed for 18 months.** Priya said 12 months or 1,000 developers. I'm pushing to 18. Here's why: a license change is a reputation event. It signals to the market that we are panicking about competition. That signal compounds with every developer who reads the changelog. If we change licenses at month 12 with 500 active developers, we lose half of them. We need either overwhelming adoption (10,000+ active developers makes the transition survivable) or a genuine existential threat from a platform player. Neither condition will be met in 12 months. Lock it for 18.

- **We invest in the template library as our primary GTM wedge, not the license.** I committed to three templates by July 17. I want every board member to hold me to that. But I also want a commitment from Marcus: one engineering week per month dedicated to onboarding templates, not features, until we have 100 active developers. Templates are the distribution mechanism. The license is irrelevant if no one can figure out what to build with it.

**Summary for the record:**

MIT. Not because open source is pure — it's not. MIT because I've lived through the defensive license conversation at a company that grew from 30 employees to a $2.5B valuation on MIT, and the license was never the bottleneck or the moat. The workflow format adoption is the moat. The governed cloud runtime is the revenue. The procurement-readiness infrastructure is the enterprise defensibility. A defensive license undermines all three by slowing adoption, triggering procurement rejection, and signaling insecurity.

The hardest path is the right one: give the code away freely, make the cloud runtime indispensable, and build the governance layer before the platform players ship theirs. That's not open-source idealism. That's the VeloCloud playbook, and it built a $2.5B company.

Now let's stop talking about licenses and go get our first 10 developers writing `.ash` files.

## Dr. Elena Vasquez

I've listened to Marcus and Priya, and I agree with the conclusion — stay MIT. But I arrive here from a different place entirely. Neither the open-source idealism that Marcus wrestles with nor the portfolio math that drives Priya's model is what decides this for me. What decides it is nine years inside an organization where procurement is a fortified city with a single gate, and the gatekeeper's only question is: "Is this license on our approved list?"

The answer for BSL, SSPL, and FSL is no. Full stop. That gate does not open.

I chaired the AI governance committee at EuropaBank. I sat in the room when our legal team reviewed vendor licenses. We had a pre-approved list: MIT, Apache 2.0, BSD, GPL variants — OSI-approved licenses with known legal contours that our outside counsel had already opined on. Every non-standard license triggered a mandatory legal review. That review took six to twelve weeks and cost $15K–$30K in external counsel fees. The vendor almost always lost the deal before the review concluded — not because the license was bad, but because the alternative vendor with MIT was already through procurement and the business unit had moved on.

This is the reality Marcus and Priya are circling but not quite naming: **a non-OSI license is not a strategic choice — it is a procurement disqualifier.** In regulated enterprises — banking, insurance, healthcare, government — compliance teams do not evaluate non-standard licenses on merit. They reject them by policy. The risk of an unvetted license clause is asymmetric: the upside of approving it is marginal (one more vendor), but the downside of approving a clause that creates regulatory exposure is a career-ending event for the compliance officer. They will choose the safe "no" every time.

**My recommendation: MIT. No other option is viable for enterprise adoption.**

Let me be explicit about what this means in practice. EuropaBank's procurement policy required OSI-approved licensing for any runtime dependency that touched production. If Ash had used BSL, we could not have deployed it in a regulated workflow — full stop. The AI governance committee I chaired would have flagged it in the architecture review, legal would have kicked it to the six-week review queue, and the business unit sponsoring the project would have picked a competitor by then. BSL is not "slightly worse for enterprise adoption." BSL is "unavailable for enterprise adoption."

**Why this protects Ash better than a defensive license.**

The premise of a defensive license is that Ash's value lives in the code — the parser, the runtime, the DSL — and that code needs legal protection. That premise is wrong for this company. Ash's value lives in the *format becoming the default* and the *governance layer becoming the requirement*. The parser is 500 lines Marcus wrote in a weekend. The runtime is a Go binary. Neither of those things is defensible. But a governance layer that produces an EU AI Act–compliant audit trail, with deterministic DAG provenance and per-node state capture that satisfies a regulator's "explain this decision" demand — that is defensible. Because it is hard. Because it requires deep domain knowledge of both AI orchestration and regulatory compliance. Because a platform player cannot ship it in a quarter.

Marcus said the moat isn't the parser — it's the format. I would go further: the moat isn't even the format — it's the *trust infrastructure* around the format. The workflow registry, the audit schema, the RBAC model, the SOC 2 certification, the procurement-friendly deployment SKUs. Those are what make an enterprise choose Ash over a bundled alternative. MIT gives away the format. That is fine. The format is the loss leader. The governance layer is the product.

I want to add something that has not been said yet because none of you have lived inside a regulated enterprise the way I have: **the compliance conversation is a sales conversation.** When a CISO or CRO evaluates an AI orchestration tool, they are not evaluating code quality. They are evaluating whether this tool reduces their personal regulatory exposure. BSL introduces *new* regulatory exposure — "is our use of this licensed dependency compliant?" — which increases their exposure. MIT eliminates that question entirely, which reduces their exposure. The enterprise buyer will always pick the tool that reduces their exposure. MIT gives us that advantage. A defensive license hands it to a competitor who stayed MIT.

Priya said something important: MIT is necessary but not sufficient. She is right. MIT is necessary for enterprise procurement to even begin. But it is not sufficient to close the deal. The sufficient conditions are: SOC 2 Type II, RBAC, SSO, on-prem/VPC deployment, DPA, SLA, annual prepaid billing, and a procurement-friendly line-item SKU structure. Those are the things that convert an MIT license into a signed purchase order.

**The biggest risk of my approach.**

The risk is not that a platform player copies our code. The risk is that a platform player ships governance features that are *good enough* before Ash does. GitHub Copilot ships agent workflows with YAML. They don't have a governance layer yet. But they have distribution, engineering resources, and enterprise relationships. If they ship audit logging and RBAC before we ship Ash Cloud with SOC 2, then the format adoption we generated with MIT becomes their installed base, not ours.

This risk is real. It does not keep me up at night the way it keeps Marcus up — because I believe enterprises will pay a premium for purpose-built governance over a bundled afterthought — but it is real. The mitigation is speed: shipping Ash Cloud as a governed runtime before the platform players ship governance as a feature.

**What else must be true for my choice to work.**

Three conditions, and I will hold everyone in this room to them:

1. **We must treat enterprise procurement readiness as a feature, not a distraction.** The CEO's commitment to Q2 2027 for SOC 2 is the minimum acceptable timeline. I need a committed budget and engineer allocation before this meeting ends. If the choice is between a new DSL feature and SOC 2 prep, the answer is always SOC 2 prep. Every week of delay is a closed deal we will never reopen.

2. **We must ship licensing, pricing, and deployment SKUs that map to how enterprises buy.** That means: annual prepaid contracts, not month-to-month. Volume discounts at 1,000+ seats documented publicly. On-prem/VPC as a line item with a price tag, not "contact sales." A DPA that procurement's lawyer can sign without redlining. If the CFO of a Fortune 500 company cannot convert our pricing page into a purchase order in one sitting, we have failed. I recorded my dissent on the pricing resolution today because the adopted model lacks on-prem SKUs. The license choice (MIT) gives us a seat at the table. The procurement readiness is what converts that seat into revenue.

3. **We must invest in the markdown engine as our wedge, not the DSL.** I said this in my profile and I will say it again at every meeting: procurement does not buy new programming languages. Domain experts write markdown. Regulators read markdown. The `.ash` DSL is an internal execution format — valuable for what it does, but it is implementation detail, not product. The product is "standardized markdown templates your compliance team can review in a code review." If our GTM motion leads with DSL, enterprise buyers will ask why they should learn a new language. If we lead with governed markdown workflows, they ask when they can start.

**Summary for the record:**

MIT is the only license that lets Ash walk through the enterprise procurement gate. BSL or any non-OSI license does not make us safer — it makes us ineligible. The real defensibility is not the code we protect but the governance infrastructure we build. My commitment to this board: I will use every enterprise relationship I have to open procurement conversations at EuropaBank and three other regulated institutions, but only if Ash remains MIT-licensed. The moment we change the license, those conversations end before they begin — because I cannot ask a CRO to approve a dependency that their own policy would reject.

Keep MIT. Ship MIT. Spend every hour we would have wasted on license engineering on SOC 2, RBAC, and enterprise procurement readiness. That is where the moat lives.
