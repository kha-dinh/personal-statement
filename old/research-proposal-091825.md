---
title: "Exploring Operating System Mechanisms for Practical and Resilient Confidential Computing"
<!-- abstract: Cloud computing underpins critical sectors such as healthcare, finance, and AI, yet remains vulnerable to escalating cyberattacks. Recent advances in "confidential cloud computing" leverage hardware mechanisms to keep sensitive data encrypted and isolated even while it is being processed. However, these systems remain exposed to "side-channel attacks" -- techniques that infer secrets indirectly by observing the side-effects of computation. Existing approaches to mitigate such attacks either impose prohibitive performance costs, restrict practical deployment, or lack a strong theoretical foundation. This proposal explores new methods to make confidential cloud computing both resilient to side-channel attacks and practical to deploy, by combining insights from operating system design with models of how information leaks through complex systems. If successful, this work will enable practical adoption of side-channel protections in cloud and provide solid theoretical foundations to strengthen trust in confidential computing. -->
fontfamily: times
fontsize: 12pt
papersize: letter
colorlinks: true
geometry: margin=2cm
number-sections: false
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{lipsum}
  - |
    \usepackage{setspace}
    \singlespacing
  - \setlength{\parskip}{0.4em}
  - |
    \usepackage{titling}
    \setlength{\droptitle}{-4em} 
    \pretitle{\centering\normalsize\bfseries}
    \posttitle{\par\vspace{-5em}}
---

**Motivation.** Cloud computing has become the backbone of modern society, relied on by hospitals, financial institutions, and AI companies to process and store highly sensitive information. Yet, its limitations continue to be exposed by cyberattacks. In 2023, 725 data breaches that exposed nearly 170 million records were reported by the U.S. healthcare sector alone. By 2024, the number of exposed records rose to almost 280 million ([HHS Breach Portal](https://ocrportal.hhs.gov/ocr/breach/breach_report.jsf)). Further, all industries are seeing increasing attack scales: the [2024 Verizon Data Breach Investigations Report (DBIR)](https://www.verizon.com/business/resources/reports/2024-dbir-data-breach-investigations-report.pdf) documented 10,626 confirmed breaches, while the [2025 report](https://www.verizon.com/business/resources/reports/2025-dbir-executive-summary.pdf) recorded 12,195 -- the highest in the report's history. Worse, _each_ data breaches cost up to USD 4.4 million on average, estimated by [a 2025 report by IBM](https://www.ibm.com/downloads/documents/us-en/131cf87b20b31c91). These costly and frequent data breaches erode trust in cloud providers and underscore the urgent need for more resilient cloud systems.




To address these risks, Trusted Execution Environments (TEEs) are introduced by technology vendors like Intel and AMD. These technologies isolate in-use data from bad actors by arming cloud processors with mechanisms to encrypt in-use data and prevent unauthorized data access. TEE technologies form the foundation of [Confidential Computing](https://blogs.nvidia.com/blog/what-is-confidential-computing/), a paradigm shift toward trustworthy private data processing in the cloud. Unfortunately, as explained shortly after, confidential computing is not without its challenges.

First, increasingly complex cloud workloads with diverse stakeholders introduce a new problem: _conflicts of interest_. This issue is demonstrated most vividly by machine learning in the cloud, where multiple stakeholders exist (Table \ref{table1}). The problem arises when each stakeholder has a security interest that is at odds with those of other stakeholders. For example, machine learning workload owners are required by regulations like [General Data Protection Regulation (GDPR)]() to handle data transparently and responsibly. Unfortunately, to prove this, they must reveal the proprietary logic to the data owner. Addressing conflicts of interest is a running challenge with confidential cloud computing, hindering its wider adoption.

\small

| Stakeholder    | Asset                      | Security interest                          |
| -------------- | -------------------------- | ------------------------------------------ |
| Data owner     | Personal Data              | Data is used transparently and responsibly |
| Workload owner | Machine learning algorithm | Hide proprietary logic                     |
| Cloud provider | Compute power              | Robust resource accounting                 |

Table: Representative stakeholders in cloud machine learning \label{table1}

\vspace{-1em}

\normalsize

Second, a critical and persistent vulnerability exists in TEE implementations: _side channels_. They are indirect signals -- such as the time a sensitive operation takes -- through which an attacker can infer private information. Side-channels are acknowledged as a formidable threat to trustworthy confidential computing ([Amazon AWS](https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/the-ec2-approach-to-preventing-side-channels.html), [Microsoft Azure](https://www.microsoft.com/en-us/research/blog/preventing-side-channels-in-the-cloud/), [IBM Cloud](https://cloud.ibm.com/docs/vpc?topic=vpc-about-confidential-computing-vpc), and [Alibaba Cloud](https://www.alibabacloud.com/blog/599241)). Efforts to completely remove side channels often run into roadblocks. Some side-channel sources are buried deep in the processor's internal circuitry (their _micro-architecture_), requiring massive hardware redesigns. Others come from everyday cloud operations, such as system memory management, and removing them would impair flexibility.

**Research Proposal\ ** There has been research that addresses the above challenges. These solutions leverage a compiler to enforce security policies on confidential programs; the compiler inserts code into programs that ensures stakeholders' security requirements or removes side-channel information leaks. These solutions require developers to rewrite or recompile the software, which makes them difficult to adopt, especially for closed-source software. Additionally, due to the expensive compiler-inserted code, many solutions can slow applications by hundreds or even thousands of times. Worse, to remedy the performance hit, some solutions make security-to-performance trade-offs that are often ad hoc and lack a sound theoretical basis.

Taking a departure from existing research, this proposal explores how _Operating Systems (OSes)_ could be repurposed to tackle confidential computing challenges. Newer iterations of confidential computing can now protect the entire virtual machine, incorporating the OS into the protection. The OS, as the mediator between software and hardware, is the ideal layer point to implement security policies without relying on a compiler.

**TODO: Detailed research plan** \lipsum[2-4]

**Fit with UBC\ \ ** UBC is an ideal base for this work under the following pillars. First, the proposed project is strongly interdisciplinary; it requires elements from _theoretical security analysis_ and _system design_ to succeed. This makes the UBC Department of Computer Science, where world-renowned expertise in both security and systems converges, an ideal institution.

I propose to carry out this research under the supervision of Prof. Aastha Mehta, a faculty member from [UBC Security & Privacy Group](https://spg.cs.ubc.ca/). TODO: Aastha's fit

At the same time, [UBC's Systopia Group](https://systopia.cs.ubc.ca/), chaired by Margo Seltzer, offers leading expertise in operating systems. TODO: Aastha's fit

I also look forward to contributing to UBC's teaching mission. I have plans for guest lectures in [CPSC 436A (Operating Systems Design and Implementation)](https://tfjmp.org/UBC-CPSC-436A/), and [CPSC 538M (Systems Security)](https://aasthakm.github.io/courses/cpsc538m.html).

The project will be conducted mainly within UBC's campus. All core work can be conducted locally using open-source platforms such as Linux and QEMU, while additional hardware requirements can be achieved remotely. Occasional short-term travel will be necessary for collaboration and to present results at leading conferences such as ACM CCS, IEEE S&P, USENIX Security, and NDSS. In this regard, the location of UBC, being close to the States where those conferences are commonly hosted, significantly cuts down travel costs.
