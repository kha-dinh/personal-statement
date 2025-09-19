---
title: "Exploring Operating System Mechanisms for Practical and Resilient Confidential Computing"
<!-- abstract: Cloud computing underpins critical sectors such as healthcare, finance, and AI, yet remains vulnerable to escalating cyberattacks. Recent advances in "confidential cloud computing" leverage hardware mechanisms to keep sensitive data encrypted and isolated even while it is being processed. However, these systems remain exposed to "side-channel attacks" -- techniques that infer secrets indirectly by observing the side-effects of computation. Existing approaches to mitigate such attacks either impose prohibitive performance costs, restrict practical deployment, or lack a strong theoretical foundation. This proposal explores new methods to make confidential cloud computing both resilient to side-channel attacks and practical to deploy, by combining insights from operating system design with models of how information leaks through complex systems. If successful, this work will enable practical adoption of side-channel protections in cloud and provide solid theoretical foundations to strengthen trust in confidential computing. -->
fontsize: 12pt
papersize: letter
<!-- mainfont: TeX Gyre Termes -->
mainfont: Times New Roman
colorlinks: true
geometry: margin=2cm
indent: true
number-sections: false
header-includes:
  - \pagenumbering{gobble}
  - \usepackage{lipsum}
  - \usepackage{booktabs,tablefootnote}
  - \usepackage{wrapfig}
  - |
    \usepackage{tikz}
  - |
    \usepackage{setspace}
    \singlespacing
  - \setlength{\parskip}{0.0em}
  - |
    \usepackage[font=small]{caption}
    \captionsetup[figure]{skip=5pt}
    \captionsetup[table]{skip=5pt}
  - |
    \usepackage{titling}
    \setlength{\droptitle}{-4em} 
    \pretitle{\centering\normalsize\bfseries}
    \posttitle{\par\vspace{-7em}}
---

<!-- markdownlint-disable MD041 MD013 -->

\noindent{}**Background.** Cloud computing underpins critical services in healthcare, finance, and AI. Yet, it faces a constant threat of cyberattacks and data breaches. In 2024, these cybercrimes exposed over [280 million records in the US's health sector alone](https://www.verizon.com/business/resources/reports/2024-dbir-data-breach-investigations-report.pdf), and in 2025, they and cost up to [$4.4 billion in remediation on average, worldwide](https://www.ibm.com/downloads/documents/us-en/131cf87b20b31c91). This not only devastate financially but also severely erode public trust in cloud.

To restore trust in cloud computing systems, cloud providers have started to isolate their customers' data from their own platforms by adopting Trusted Execution Environments (TEEs), built on top of modern CPU features like AMD SEV. TEEs protect customers' data against a strong threat model, resistant to even attacks from a cloud administrator. TEEs form the foundation of [Cloud Confidential Computing (CCC)](https://blogs.nvidia.com/blog/what-is-confidential-computing/), a paradigm shift toward trustworthy private data processing in cloud.

\def\figwidth{5.7}\begin{wrapfigure}{l}{\figwidth cm} \vspace{-1em}\includegraphics[width=\figwidth cm]{./tikz/cvm.pdf} \caption{VM-Level TEEs in Cloud Confidential Computing \label{cvm}\vspace{-1em}} \end{wrapfigure}

The latest TEEs can now fully isolate virtual machines (VMs), made possible by technologies like AMD SEV (\autoref{cvm}). This improves usability by safeguarding existing workloads with minimal modifications and boosts performance by reducing interactions with the host system. However, this advancement means that TEEs must now secure the entire software stack of the VM -- or its Trusted Computing Base (TCB). In this picture, the Operating System (OS) is particularly problematic. As of 2025, the Linux kernel contains around [40 million lines of code](https://www.stackscale.com/blog/linux-kernel-surpasses-40-million-lines-code/) -- [seeing over 3,500 vulnerabilities in 2024](https://tuxcare.com/blog/the-linux-kernel-cve-flood-continues-unabated-in-2025/) that attackers can leverage. Furthermore, the OS's complex interactions with the underlying hardware -- now being virtualized by the untrusted platform -- further [complicate efforts to secure CCC](https://web.cs.toronto.edu/news-events/news/university-of-toronto-team-discovers-vulnerability-at-hardware-software-boundary-in-cloud-systems).

\vspace{.4em}\noindent{}**Proposal overview.** This proposal seeks to make CCC more robust and practical, building on the observation that the industries' shift toward VM-level TEEs also exposes a golden opportunity: the OS can now actively shape the security of CCC. My doctoral studies demonstrated the potential of this direction by designing [INCOGNITOS](https://www.computer.org/csdl/proceedings-article/sp/2025/223600d860/26hiVMUi1MI), a side-channel mitigation technique that harnessed OS components such as memory management and task scheduling. The work provided a proof of concept, showing that OS abstractions can be employed for principled and deployable security. Building on that foundation, my postdoctoral research will develop a broader class of OS-supported techniques that address the practical challenges of CCC deployments.

At UBC, I will pursue this agenda under the supervision of Prof. Aastha Mehta; her expertise in both systems security and OS will be invaluable to the research. Moreover, I plan to enrich this research with perspectives from UBC's researchers, especially systems researchers at Systopia Lab and cloud computing researchers at CIRRUS Lab. Plan for these collaborations will be detailed in the remainder of this proposal, along with the challenges that will be the focus of my research: _side-channel attacks_ and _conflict of interest_.

\vspace{.4em}\noindent{}**Focus 1: Side-channel attacks.** _Side channels_ are critical and persistent vulnerabilities at the software-hardware boundary of TEEs. They are indirect signals -- such as the time difference measured when accessing a memory location -- through which an attacker can infer private information. Such attacks are widely acknowledged as a formidable threat to CCC ([AWS](https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/the-ec2-approach-to-preventing-side-channels.html), [Azure](https://www.microsoft.com/en-us/research/blog/preventing-side-channels-in-the-cloud/), [IBM](https://cloud.ibm.com/docs/vpc?topic=vpc-about-confidential-computing-vpc), and [Alibaba](https://www.alibabacloud.com/blog/599241)). Efforts to completely remove side channels often run into roadblocks; some are buried deep in the processor's internal circuitry  requiring massive hardware redesigns to eliminate, others come from everyday cloud resource management operations and removing them would impair flexibility.

A more practical, less intrusive approach is to mitigate these side-channel by transforming the sensitive application to obscure side-channel signals. Unfortunately, current state-of-the-art mitigation techniques fall short; systems such as Klotski and Obelix are difficult to adopt as they require developers to rewrite or recompile their entire software. Even when applied, they can slow applications by hundreds or even thousands of times. Worse, to remedy the severe performance hit, security trade-off are often made, but they are ad hoc, without a sound theoretical basis. 

My postdoctoral work will tackle the side-channel challenge from an OS vantage point. The prototype introduced during my Doctoral studies has limited deployability, relying on a minimal OS. I aim to push this direction further by incorporating side-channel mitigation into the commodity Linux OS to support diverse cloud workloads. This direction especially synergizes with Aastha Mehta's profound experiences on side-channel attacks and defenses. Further, the work of userspace memory management by Margo Seltzer and Alexandra Fedorova will play an essential role in making the side-channel mitigation technique using memory management practical. The large TCB of commodity OSes also makes side-channel elimination particularly challenging -- it requires tracking potential side-channel leaks across millions of lines of code. To this end, the study of cross-system information flow tracking, pioneered by Margo Selter and Thomas Pasquier, makes it a tractable problem. 


<!-- \begin{wraptable}{r}{9cm} -->
<!-- \footnotesize -->
<!-- \begin{tabular}{p{2cm}p{2cm}p{4cm}}\\ -->
<!-- \toprule   -->
<!-- Stakeholder & Asset & Security interest \\ -->
<!-- \midrule -->
<!-- Data owner \& Serice users & Personal Data  & Data is used transparently and responsibly \\ -->
<!-- \midrule -->
<!-- Training owner & ML algorithms  & Hide proprietary logic \\ -->
<!-- \midrule -->
<!-- Inference owner & Inference algorithms  & Hide proprietary logic \\ -->
<!-- \bottomrule -->
<!-- \end{tabular} -->
<!-- \caption{Test}\label{table1} -->
<!-- \end{wraptable}  -->

\vspace{.4em}\noindent{}**Focus 2: Resolving stakeholders' conflicts of interest.** Increasingly complex cloud workloads with diverse stakeholders introduce a unique problem: _conflicts of interest_. This issue is demonstrated most vividly by machine learning in the cloud, where multiple stakeholders exist (\autoref{table1}). The problem arises when each stakeholder has a interest that is at odds with those of other stakeholders. For example, machine learning workload owners are required by regulations like [the General Data Protection Regulation (GDPR)](https://gdpr-info.eu/) to handle data transparently and responsibly. Unfortunately, proving this requires an auditor to carefully scrutinize the training and inference code, requiring the model owner to reveal their proprietary business logic. While CCC is a powerful paradigm that allow parties to establish trust in the computation, it does not solve this issue.

\footnotesize

| Stakeholder                    | Asset                        | Interest                                   | Untrusted party                 |
| ------------------------------ | ---------------------------- | ------------------------------------------ | ------------------------------- |
| Data owners & ML service users | Personal data                | Data is used transparently and responsibly | Model owners & Cloud providers  |
| Model/ML services owners       | ML algorithms, model weights | Hide proprietary logic & ML model          | Service users & Cloud providers |
| Cloud providers                | Computing platform           | Monetize computation platform              | --                              |

Table: Conflicts of interests in cloud machine learning. While CCC excludes cloud providers from the threat model, the conflicts persist. \label{table1}

\normalsize

This challenge has been tackled by many research work; but they have limited compatiblity with modern cloud workloads like machine learning.


These solutions leverage a compiler to enforce security policies on confidential programs; the compiler inserts code into programs that ensures stakeholders' security requirements or removes side-channel information leaks. These solutions require developers to rewrite or recompile the software, which makes them difficult to adopt, especially for closed-source software. Additionally, due to the expensive compiler-inserted code, many solutions can slow applications by hundreds or even thousands of times. Worse, to remedy the performance hit, some solutions make security-to-performance trade-offs that are often ad hoc and lack a sound theoretical basis.

\newpage

# Appendix: Guide (REMOVE IN FINAL)

The proposal should be written in clear, non-technical language that allows a non-specialist to comprehend the overall content and importance of the work. Members of the Killam Postdoctoral Fellowships and Prizes Committee are from abroad range disciplines and may not have expertise in your area of study.

Although the fellowship may be used to extend or expand upon doctoral work, it must be made clear that you are not intending to use the award to wrap up a thesis. While it is expected that a postdoctoral fellow will be taking the next step beyond the PhD thesis, you must differentiate clearly between the postdoctoral project and the thesis research. Feel free to include hyperlinks to provide links to additional information.

As applicants must make UBC their base, it is important -- particularly for applicants whose primary research materials are elsewhere -- to indicate what travel is involved, to where, and for how long. You should describe how you will deal with the remoteness of the primary materials.

The adjudication committee is very interested in “fit” with the selected UBC department or unit and the university’s research programs. You must provide information on how your research relates to that of specific campus programs and advisors. If a colloquium is envisioned, a possible title should be proposed. If you will visit in classes, please suggest which ones. Since inter-disciplinarity is often a valuable dimension (the Killam Trusts declares that a candidate shall not be “a one-sided person”), specific details on proposed inter-departmental connections are welcome.
