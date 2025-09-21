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

\def\figwidth{5.7}\begin{wrapfigure}{r}{\figwidth cm} \vspace{-1em}\includegraphics[width=\figwidth cm]{./tikz/cvm.pdf} \caption{VM-Level TEEs in Cloud Confidential Computing \label{cvm}\vspace{-1em}} \end{wrapfigure}

The latest TEEs can now fully isolate virtual machines (VMs), made possible by technologies like AMD SEV (\autoref{cvm}). This improves usability by safeguarding existing workloads with minimal modifications and boosts performance by reducing interactions with the host system. However, this advancement means that TEEs must now secure the entire software stack of the VM -- or its Trusted Computing Base (TCB). In this picture, the Operating System (OS) is particularly problematic. As of 2025, the Linux kernel contains around [40 million lines of code](https://www.stackscale.com/blog/linux-kernel-surpasses-40-million-lines-code/) -- [seeing over 3,500 vulnerabilities in 2024](https://tuxcare.com/blog/the-linux-kernel-cve-flood-continues-unabated-in-2025/) that attackers can leverage. Furthermore, the OS's complex interactions with the underlying hardware -- now being virtualized by the untrusted platform -- further [complicate efforts to secure CCC](https://web.cs.toronto.edu/news-events/news/university-of-toronto-team-discovers-vulnerability-at-hardware-software-boundary-in-cloud-systems).

\vspace{.4em}\noindent{}**Proposal overview.** This proposal seeks to make CCC more robust and practical, building on the observation that the industries' shift toward VM-level TEEs also exposes a golden opportunity: the OS can now actively shape the security of CCC. My doctoral studies demonstrated the potential of this direction by designing [INCOGNITOS](https://www.computer.org/csdl/proceedings-article/sp/2025/223600d860/26hiVMUi1MI), a side-channel mitigation technique for CCC that harnessed OS components such as memory management and task scheduling. This proof of concept shows that OS abstractions can be employed for principled and deployable security. Building on that foundation, I will develop a broader class of OS-supported techniques that address the practical challenges of CCC deployments.

At UBC, I will pursue this agenda under the supervision of Prof. *Aastha Mehta*, who has deep expertise in both systems security and OS. I will also enrich this research with perspectives from UBC's researchers, especially systems and cloud computing researchers at Systopia Lab and CIRRUS Lab. Plans for these collaborations will be detailed in the remainder of this proposal, along with the focuses of my postdoctoral research: _side-channel attacks_ and _private data processing_.

\vspace{.4em}\noindent{}**Focus 1: Side-channel attacks.** _Side channels_ are a critical yet persistent class of vulnerabilities at the software-hardware boundary of TEEs. They are indirect signals -- such as the time difference measured when accessing a memory location -- through which an attacker can infer private information. Such attacks are widely acknowledged as a formidable threat to CCC ([AWS](https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/the-ec2-approach-to-preventing-side-channels.html), [Azure](https://www.microsoft.com/en-us/research/blog/preventing-side-channels-in-the-cloud/), [IBM](https://cloud.ibm.com/docs/vpc?topic=vpc-about-confidential-computing-vpc), and [Alibaba](https://www.alibabacloud.com/blog/599241)). Efforts to completely remove side channels often run into roadblocks: some side channels are buried deep in the processor's internal circuitry, requiring massive hardware redesigns to eliminate; others come from everyday cloud resource management operations, and removing them would impair flexibility.

A more practical, less intrusive approach is to mitigate these side-channel by transforming the sensitive program to obscure side-channel signals. However, current state-of-the-art mitigation techniques fall short; systems such as [Klotski]() and [Obelix]() are difficult to adopt as they require developers to rewrite or recompile their entire software. Even when applied, these systems can slow programs by hundreds or even thousands of times. Worse, to remedy the severe performance hit, security trade-off are often made, but they are ad hoc, without a sound theoretical basis.

My postdoctoral work will tackle the limitations of previous research from an OS vantage point. I aim to extend the limited prototype of my doctoral research implemented on a minimal OS, by incorporating side-channel mitigation into Linux, an OS most widely used in cloud data centers. Also, I plan to explore theoretical models to enable principled trade-offs that enable better performance. 

This direction synergizes with the collective expertise at UBC. Primarily, my supervisor, *Aastha Mehta*, with profound experience in side-channel attacks on TEEs and formal models for side-channel defenses, would provide invaluable feedback to the research. Further, the work of userspace memory management by *Margo Seltzer* and *Alexandra Fedorova* will play an essential role in making the side-channel mitigation technique using memory management practical in a complex OS such as Linux. The large TCB of commodity OSes also makes side-channel elimination particularly challenging -- it requires tracking potential leaks across millions of lines of code. To this end, the study of cross-system *information flow tracking*, pioneered by *Margo Selter* and *Thomas Pasquier*, will make it a tractable problem.

\begin{wraptable}{r}{8.5cm}
\vspace{-1em}
\footnotesize
\centering
\begin{tabular}{lp{2.2cm}p{2.5cm}}
\toprule
Stakeholder       & Sensitive Asset              & Security Interest                         \\
\midrule
Service users     & Personal data                & Ensure data confidentiality      \\
Service providers & Proprietary data processing   & Keep trade secrets confidential \\
\bottomrule
\end{tabular}
\caption{Representative private data processing stakeholders, and their assets and interests.\vspace{-1em}}
\label{table1}
\end{wraptable}

\vspace{.4em}\noindent{}**Focus 2: Private data processing.** A common scenario for CCC deployments is *private data processing* involving multiple stakeholders, as shown in \autoref{table1}. For instance, companies like [23andMe](https://www.23andme.com/) provide personal health data analytics as a cloud service. Its users upload private data to the service's server, which runs a health analytics program on the data and returns the results to the user. The cloud provider must handle users' personal data carefully, but this is often not trusted by cloud users. This results in a dilemma: On the one hand, the user wants to verify that the service provider is using their data responsibly; e.g., only for analytic purposes. On the other hand, to prove this, the service provider must publicize its data processing to users for verification, which might contain trade secrets.


\def\figwidth{5.2}\begin{wrapfigure}{l}{\figwidth cm} \vspace{-1em}\includegraphics[width=\figwidth cm]{./tikz/stakeholders.pdf} \caption{How CCC resolves stakeholders' conflicts.\label{stakeholders}\vspace{-1em}} \end{wrapfigure}

To resolve this *conflict of interests*, existing deployments employ a mediator in a TEE, which is trusted by both service users and providers (\autoref{stakeholders}). The service provider first sends the data processing program to the mediator, trusting it to keep the program secret. Similarly, the users provide personal data without needing to examine the program. On users' data, the mediator now runs the service provider's program in a way that strictly maintains the confidentiality of users' data.


Unfortunately, most research prototypes addressing this challenge fail to introduce a deployable solution. Recent solutions like [PAVE](https://dl.acm.org/doi/10.1145/3676641.3716266) and [Erebor](https://dl.acm.org/doi/pdf/10.1145/3689031.3717464) enforce this by placing the program inside a sandbox. The sandbox enforces strict information flow control on the service provider's program, for instance, preventing it from saving personal data to a file or communicating with other programs. As a result, this approach severely limits flexibility and compatibility with many workloads, especially those involving cooperating programs.


My research aims to incorporate a trusted mediator into the in-TEE OS. I plan to achieve this through dynamic information flow tracking, a common technique in OS research. With information flow tracking, the OS would prevent only at the point at which sensitive data is about to be exported to untrusted locations, while allowing benign file accesses and network operations. Thus, the system would be compatible with a wide range of cloud workloads. As in Focus 1, I envision that whole-system information flow tracking expertise from *Margo Selter* and *Thomas Pasquier* will be of tremendous help. Scaling the trusted mediator design across cloud machines would also require distributed cloud computing expertise, which I plan to employ the help of *Mohammad Shahrad* from the ECE department.





\newpage

# Appendix: Guide (REMOVE IN FINAL)

The proposal should be written in clear, non-technical language that allows a non-specialist to comprehend the overall content and importance of the work. Members of the Killam Postdoctoral Fellowships and Prizes Committee are from abroad range disciplines and may not have expertise in your area of study.

Although the fellowship may be used to extend or expand upon doctoral work, it must be made clear that you are not intending to use the award to wrap up a thesis. While it is expected that a postdoctoral fellow will be taking the next step beyond the PhD thesis, you must differentiate clearly between the postdoctoral project and the thesis research. Feel free to include hyperlinks to provide links to additional information.

As applicants must make UBC their base, it is important -- particularly for applicants whose primary research materials are elsewhere -- to indicate what travel is involved, to where, and for how long. You should describe how you will deal with the remoteness of the primary materials.

The adjudication committee is very interested in “fit” with the selected UBC department or unit and the university’s research programs. You must provide information on how your research relates to that of specific campus programs and advisors. If a colloquium is envisioned, a possible title should be proposed. If you will visit in classes, please suggest which ones. Since inter-disciplinarity is often a valuable dimension (the Killam Trusts declares that a candidate shall not be “a one-sided person”), specific details on proposed inter-departmental connections are welcome.
