---
title: Practical and Principled Side-channel Resilience in Confidential Cloud Computing
colorlinks: true
abstract: Cloud computing underpins critical sectors such as healthcare, finance, and AI, yet remains vulnerable to escalating cyberattacks. Recent advances in "confidential cloud computing" leverage hardware mechanisms to keep sensitive data encrypted and isolated even while it is being processed. However, these systems remain exposed to "side-channel attacks" -- techniques that infer secrets indirectly by observing the side-effects of computation. Existing approaches to mitigate such attacks either impose prohibitive performance costs, restrict practical deployment, or lack a strong theoretical foundation. This proposal explores new methods to make confidential cloud computing both resilient to side-channel attacks and practical to deploy, by combining insights from operating system design with models of how information leaks through complex systems. If successful, this work will enable practical adoption of side-channel protections in cloud and provide solid theoretical foundations to strengthen trust in confidential computing.
---

# Research Proposal

#### Proposal Summary

Side-channel attacks threaten the security of confidential computing in cloud. This proposal explores new methods to make confidential cloud computing both resilient to side-channel attacks and practical to deploy, by combining insights from operating system design with formal models of how information leaks through complex systems. It integrates the side-channel mitigation techniques into the operating system layer, taking advantages of its [resource management capabilities](https://www.ibm.com/think/topics/operating-systems). This enables _transparency_ -- a protected program no longer have to be aware of the protection being enforced. The OS-level side-channel mitigation mechanism follows a formalized model of side-channel information leak. This model guarantees the security properties of the system, and ensure that security-to-performance trade-offs, if any are made are, are _principled_. This avoids fragile security assumptions commonly observed in similar systems. If successful, this work will enable practical adoption of side-channel protections in cloud across a wide variety of sensitive workloads, such as training AI models, genomic analysis, or financial transaction. It also provides solid theoretical foundations to audit cloud systems and strengthen trust in confidential computing.

#### Background & Motivation

Cloud computing has become the backbone of modern society. Hospitals, financial institutions, and AI companies rely on it to process and store highly sensitive information. Yet, cyberattacks continue to expose the limitations of cloud. In 2023, the U.S. healthcare sector alone reported 725 breaches, exposing nearly 170 million records; by 2024, that figure rose to almost 280 million ([HHS Breach Portal](https://ocrportal.hhs.gov/ocr/breach/breach_report.jsf)). Across all industries, the scale of attacks is also accelerating: the [2024 Verizon Data Breach Investigations Report (DBIR)](https://www.verizon.com/business/resources/reports/2024-dbir-data-breach-investigations-report.pdf) documented 10,626 confirmed breaches, while the [2025 report](https://www.verizon.com/business/resources/reports/2025-dbir-executive-summary.pdf) recorded 12,195 -- the highest in the report’s history. Not only the lost of personal information, data breaches also causes significant monetary loss -- [a 2025 report by IBM](https://www.ibm.com/downloads/documents/us-en/131cf87b20b31c91) estimates that across the globe, _each_ data breaches cost up to USD 4.4 million on average. These costly and frequent data breaches erode trust in cloud providers’ ability to safeguard private data, underscoring the urgent need for more resilient cloud systems.

To address these risks, technology vendors like Intel and AMD have introduced Trusted Execution Environments (TEEs). These technologies enhance cloud processors with mechanisms that securely isolate in-use data from untrustworthy entities. TEE achieves strong isolation through hardware mechanisms that keep data encrypted even while being used, and prevent unauthorized data access, even from cloud providers, who own the machines. TEEs form the foundation of [Confidential Computing](https://blogs.nvidia.com/blog/what-is-confidential-computing/), a paradigm shift toward trustworthy private data processing in cloud. Yet, despite strong data isolation, there remains a subtle but critical vulnerability in TEEs: _side channels_. A side channel is an indirect signal -- such as the time a sensitive operation takes, or the memory access pattern that it makes -- through which an attacker can infer private information, bypassing even memory encryption. Major cloud providers had acknowledged side-channel leaks to be a formidable threat to trustworthy confidential computing ([Amazon AWS](https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/the-ec2-approach-to-preventing-side-channels.html), [Microsoft Azure](https://www.microsoft.com/en-us/research/blog/preventing-side-channels-in-the-cloud/), [IBM Cloud](https://cloud.ibm.com/docs/vpc?topic=vpc-about-confidential-computing-vpc) and [Alibaba Cloud](https://www.alibabacloud.com/blog/599241)).

Efforts to completely remove side channels often run into roadblocks. Some sources of leak are buried deep in the processor's internal circuitry (their _micro-architecture_), requiring massive hardware redesigns. Others come from everyday cloud operations -- such as how cloud providers manage system memory -- and removing them would impair flexibility. Thus, a more practical, less intrusive approach is to _mitigate_ these leaks from within -- making side-channel signals attackers can gather confusing or incomplete. Unfortunately, current state-of-the-art mitigation techniques fall short. Cutting-edge systems such as Klotski and Obelix only work if developers rewrite or recompile their entire software, a barrier to adoption. Even when applied, they can slow applications by hundreds or even thousands of times. Worse, to remedy the severe performance hit, security trade-off are often made, but they are ad hoc, without a sound theoretical basis.

#### Distinguishing with Doctoral Research

My doctoral research is on implementing OS security mechnanisms with emerging hardware. At the 4th year of my Ph.D., I worked on IncognitOS a project that conceptualized and pioneered some ideas that are presented in this proposal. Specifically, it showed the promise of incorporating side-channel mitigation mechanisms into an OS. However, with limited expertises in both formal security and operating systems design, my doctoral project is all but scratching the surface of what is possible with this direction.

#### Detailed Research Plan

The research activity of this will falls across two main projects, with the time of each expected to be one year.

- **Year-1: Exploring Practical OS-level mechanisms for side channel mitigation** \lipsum[2-2]
- **Year-2: Formalizing security properties and policy formation** \lipsum[2-2]

<!-- #### Expected Impact -->

# Fit with University of British Columbia

UBC provides an ideal environment for this work under the following pillars.

#### Interdisciplinary Reach

The proposed project is strongly _interdisciplinary_ -- as outlined above, it requires elements from _theoretical security analysis_ and _system design_ to succeed. This makes UBC Department of Computer Science, where world-renouned expertise in both security and system converge, its ideal institution. Furthermore, UBC's research environment that encourage openness and collaboration, provides critical opportunities for different to contribute to this project.

I propose to carry out this research under the supervision of Prof. Aastha Mehta, a faculty from [UBC Security & Privacy Group](https://spg.cs.ubc.ca/). Aastha's expertise in systems security strongly complement the project; Her recent work on cloud side-channel attacks ([Relocate-Vote](help.com)) and mitigation ([NetShaper](help.com)) provide an ideal foundation for my postdoctoral work. Particularly, her teams' expertises on ex ciphertext side-channel

At the same time, [UBC's Systopia Group](https://systopia.cs.ubc.ca/), chaired by Margo Seltzer, offers leading expertise in operating systems.

#### Teaching Engagement

I also look forward to contributing to UBC’s teaching mission. I have plans for guest-lectures in [CPSC 436A (Operating Systems Design and Implementation)](https://tfjmp.org/UBC-CPSC-436A/), and [CPSC 538M (Systems Security)](https://aasthakm.github.io/courses/cpsc538m.html). Being a inter-disciplinary research, I can present it across multiple courses.

#### Logistic

The project will be conducting mainly within UBC. All core work can be conducted locally using open-source platforms such as Linux and QEMU, while additional hardware requirement can be achieved remotely. Occasional short-term travel will be necessary for collaboration and to present results at leading conferences such as ACM CCS, IEEE S&P, USENIX Security and NDSS. In this regard, the location of UBC, being close to the States where those conferences are commonly hosted, significantly cuts down travel costs.

\newpage

# Appendix: Guide (REMOVE IN FINAL)

The proposal should be written in clear, non-technical language that allows a non-specialist to comprehend the overall content and importance of the work. Members of the Killam Postdoctoral Fellowships and Prizes Committee are from abroad range disciplines and may not have expertise in your area of study.

Although the fellowship may be used to extend or expand upon doctoral work, it must be made clear that you are not intending to use the award to wrap up a thesis. While it is expected that a postdoctoral fellow will be taking the next step beyond the PhD thesis, you must differentiate clearly between the postdoctoral project and the thesis research. Feel free to include hyperlinks to provide links to additional information.

As applicants must make UBC their base, it is important -- particularly for applicants whose primary research materials are elsewhere -- to indicate what travel is involved, to where, and for how long. You should describe how you will deal with the remoteness of the primary materials.

The adjudication committee is very interested in “fit” with the selected UBC department or unit and the university’s research programs. You must provide information on how your research relates to that of specific campus programs and advisors. If a colloquium is envisioned, a possible title should be proposed. If you will visit in classes, please suggest which ones. Since inter-disciplinarity is often a valuable dimension (the Killam Trusts declares that a candidate shall not be “a one-sided person”), specific details on proposed inter-departmental connections are welcome.
