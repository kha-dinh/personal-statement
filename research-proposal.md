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

<!-- markdownlint-disable MD041 MD013 MD036 -->

\noindent{}**Background.** Cloud computing underpins critical services in healthcare, finance, and AI. Yet, it faces a constant threat of cyberattacks and data breaches. In 2024, these cybercrimes exposed over [280 million records in the US's health sector alone](https://www.verizon.com/business/resources/reports/2024-dbir-data-breach-investigations-report.pdf). Data breaches are not only financially devastating for the cloud providers hosting customer services, costing up to [$4.4 billion in remediation on average in 2025](https://www.ibm.com/downloads/documents/us-en/131cf87b20b31c91), they also erode customers' trust in cloud providers.

\def\figwidth{5.7}\begin{wrapfigure}{r}{\figwidth cm} \vspace{-1em}\includegraphics[width=\figwidth cm]{./tikz/cvm.pdf} \caption{Modern TEE design\label{cvm}\vspace{-1em}} \end{wrapfigure}

To regain trust, cloud providers are now strengthening the security of their own infrastructure and isolating their customers' systems from it to minimize the risk of compromises in their platform from permeating to customers. In the latter case, particularly, providers are increasingly adopting specialized hardware from compute vendors (e.g., Intel, AMD). These are new processors with secure primitives built into the silicon that enable the creation of a secure "bubble" on the platfom, called a Trusted Execution Environment or TEE, which protects sensitive data and programs, even if the rest of the system, even the cloud administrator, are compromised.

After the initial exploration of TEE designs, the community has settled on the idea of isolating an application along with its complete execution environment, including libraries and supporting software, within a single TEE. This design has helped migrate many applications into TEEs with reduced performance and engineering costs. Especially, companies have been deploying cutting-edge workloads such as [large language model inference into TEEs](https://docs.privatemode.ai/security) for their protection with only trivial adaptation.

\vspace{.4em}\noindent{}**Challenges of modern TEEs.** This direction in TEE design introduces two new security challenges that I plan to tackle in my postdoctoral studies. The first challenge lies in the huge amount of code now being placed inside a TEE, on which the security guarantees for the customer's application and data depend. This code (called the trusted computing base or the TCB of an application) includes the operating system, often consisting of several [million lines of code](https://www.stackscale.com/blog/linux-kernel-surpasses-40-million-lines-code/) and known to have [thousands of vulnerabilities](https://tuxcare.com/blog/the-linux-kernel-cve-flood-continues-unabated-in-2025/) that the adversaries could exploit to compromise the sensitive application. Thus, making TEE code resilient against compromises, ensuring that vulnerabilities have minimal impact on the security guarantees offered to cloud customers, is a key research challenge for the community.

Second, as a component of TEEs, the role of operating systems must now be rethought. Unlike normal applications, the operating system's primary task is to manage system resources, such as memory and files, by utilizing its access to low-level hardware mechanisms that provide fine control over software running on the system. Importantly, the operating system's high degree of control not only enables transparent resource management but also offers powerful tools for building practical in-TEE security mechanisms. The work conducted during my doctoral studies demonstrated the promise of this approach, leveraging OS capabilities to implement practical TEE self-defense mechanisms, particularly against side-channel attacks. Building on that foundation, I plan to tackle the challenge of exploring a broader class of OS-supported techniques that address the issues in practical TEE deployments.

<!-- At UBC, I will pursue this agenda under the supervision of Prof. _Aastha Mehta_, who has deep expertise in both systems security and OS. I will also enrich this research with perspectives from UBC's researchers, especially systems and cloud computing researchers at Systopia Lab and CIRRUS Lab. Plans for these collaborations will be detailed in the remainder of this proposal. -->

**Toward taming large TCB.** Securing the application TCB is an essential challenge given the complexity of modern TEEs. Over the years, research has sought to tackle this challenge in three ways. The first approach proposes comprehensively testing the code placed inside the TEE to detect mistakes. However, applying this to a large codebase, such as the OS, would require an insurmountable effort and is unlikely to find all the bugs. The second approach is compartmentalization, which splits a large codebase into smaller, isolated components. The intuition is simple: if each component is placed in a "cage" where its failures cannot spread, then the system as a whole becomes more robust to attacks. Still, the decision of which components to place these cages into is largely unexplored. The third approach is TCB reduction, which seeks to minimize the code running inside the TEE, based on the belief that code size correlates with security risk. While this principle holds some truth, an exclusive focus on code size is misleading. It can sacrifice system performance by removing features, and more importantly, it overlooks where the risky code actually resides -- the means by which trusted and untrusted worlds communicate, or their interfaces.

<!-- However, in compartmentalized codebases, there is still a significant risk, particularly at the point where different compartments communicate, which attackers can use to perform attacks, and this attack vector is often overlooked by the research community. -->

My proposal focuses on securing the TCB of TEEs around the interfaces. These interfaces, often inherited from legacy systems, were rarely designed with strong adversarial models in mind; yet, they are easy targets for attacks. For instance, recent research has shown that the interfaces where the TEE communicates with the outside world expose critical vulnerabilities that leak sensitive data. Based on this observation, I plan to pursue research in two strategies. First, building on my experience in software compartmentalization, I plan to explore methodologies that compartmentalize code interacting with the interfaces, thereby containing the impact of the untrusted platform on security. Second, I will revisit legacy interface design choices, rethinking interfaces from the ground up with security as a first-class goal, rather than an afterthought. By focusing security decisions at the interfaces where they matter, TEE designs can manage complexity in a principled manner without sacrificing functionality.

**Exploration of OS as a security component.** My research toward this area will focus on two main challenges with modern TEEs: (i) side-channel mitgation and (ii) private data processing.

\vspace{.4em}\noindent{}**Focus 1: Practical Side-channel attacks mitigations.** _Side channels_ are a critical yet persistent class of vulnerabilities at the software-hardware boundary of TEEs. They are indirect signals -- such as the time difference measured when accessing a memory location -- through which an attacker can infer private information. Such attacks are widely acknowledged as a formidable threat to CCC ([AWS](https://docs.aws.amazon.com/whitepapers/latest/security-design-of-aws-nitro-system/the-ec2-approach-to-preventing-side-channels.html), [Azure](https://www.microsoft.com/en-us/research/blog/preventing-side-channels-in-the-cloud/), [IBM](https://cloud.ibm.com/docs/vpc?topic=vpc-about-confidential-computing-vpc), and [Alibaba](https://www.alibabacloud.com/blog/599241)). Efforts to completely remove side channels often run into roadblocks: some side channels are buried deep in the processor's internal circuitry, requiring massive hardware redesigns to eliminate; others come from everyday cloud resource management operations, and removing them would impair flexibility.

A more practical, less intrusive approach is to mitigate these side-channels by obscuring side-channel signals from programs. However, current state-of-the-art mitigation techniques fall short; systems such as [Klotski]() and [Obelix]() are complex to adopt as they require developers to rewrite or recompile their entire software. Even when applied, these systems can slow programs by hundreds or even thousands of times. Worse, to remedy the severe performance hit, security trade-offs are often made, but they are ad hoc and lack a sound theoretical basis.

At UBC, my research will tackle these challenges under the supervision of Prof. Aastha Mehta, who has deep expertise in both systems security and OSes. I will also enrich this research with perspectives from UBC's researchers, especially systems and cloud computing researchers at Systopia Lab and CIRRUS Lab. Plans for these collaborations will be detailed in the remainder of this proposal.

My postdoctoral work will tackle the limitations of previous research from an OS vantage point. I aim to extend the limited prototype of my doctoral research implemented on a minimal OS by incorporating side-channel mitigation into Linux, an OS most widely used in cloud data centers. Also, I plan to explore theoretical models to enable principled trade-offs that enable better performance.

This direction synergizes with the collective expertise at UBC. Primarily, my supervisor, _Aastha Mehta_, with profound experience in side-channel attacks on TEEs and formal models for side-channel defenses, would provide invaluable feedback to the research. Further, the work of userspace memory management by _Margo Seltzer_ and _Alexandra Fedorova_ will play an essential role in making the side-channel mitigation technique using memory management practical in a complex OS such as Linux. The large TCB of commodity OSes also makes side-channel elimination particularly challenging -- it requires tracking potential leaks across millions of lines of code. To this end, the study of cross-system _information flow tracking_, pioneered by _Margo Selter_ and _Thomas Pasquier_, will make it a tractable problem.

\input{./stakeholder-table.tex}

\vspace{.4em}\noindent{}**Focus 2: Private data processing.** A common scenario for CCC deployments is _private data processing_ involving multiple stakeholders, as shown in \autoref{table1}. For instance, companies like [23andMe](https://www.23andme.com/) provide personal health data analytics as a cloud service. Its users upload private data to the service's server, which runs a health analytics program on the data and returns the results to the user. The service must handle users' personal data carefully -- this is, while mandated by regulations like [GDPR](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng), often not trusted by users. A dilemma arises: On the one hand, the user wants to verify that the service is using their data responsibly, for example, never giving it to third parties. On the other hand, to prove this, the service must publicize its data processing to users for verification, which might contain trade secrets.

\def\figwidth{5.2}\begin{wrapfigure}{l}{\figwidth cm} \vspace{-1em}\includegraphics[width=\figwidth cm]{./tikz/stakeholders.pdf} \caption{How CCC resolves stakeholders' conflicts.\label{stakeholders}\vspace{-1em}} \end{wrapfigure}

To resolve this _conflict of interests_, existing deployments employ a mediator in a TEE, which is trusted by both service users and providers (\autoref{stakeholders}). The service provider first sends the data processing program to the mediator, trusting it to keep the program secret. Similarly, the users provide personal data without needing to examine the program. On users' data, the mediator now runs the service provider's program in a way that strictly maintains the confidentiality of users' data.

Unfortunately, most research prototypes addressing this challenge fail to introduce a deployable solution. Recent solutions like [PAVE](https://dl.acm.org/doi/10.1145/3676641.3716266) and [Erebor](https://dl.acm.org/doi/pdf/10.1145/3689031.3717464) achieve security by placing the program inside a sandbox. The sandbox enforces strict information flow control on the program, for instance, preventing it from saving personal data to a file or communicating with other programs. As a result, this approach severely limits flexibility and compatibility with many workloads, especially complex ones and ones involving cooperating programs.

My proposal looks to incorporate a trusted mediator into the OS to improve usability. This is achieved through dynamic information flow tracking, a common technique in OS research. Using this, the mediator would prevent only the point at which sensitive data is about to be extorted, while allowing benign file accesses and network operations. Thus, the private data processing system would be compatible with a wide range of cloud workloads. I envision that whole-system information flow tracking expertise from _Margo Selter_ and _Thomas Pasquier_ will be of tremendous help. Scaling the trusted mediator design across cloud machines would also require distributed cloud computing expertise, which I plan to employ the help of _Mohammad Shahrad_ from the ECE department.

\newpage

# Appendix: Guide (REMOVE IN FINAL)

The proposal should be written in clear, non-technical language that allows a non-specialist to comprehend the overall content and importance of the work. Members of the Killam Postdoctoral Fellowships and Prizes Committee are from abroad range disciplines and may not have expertise in your area of study.

Although the fellowship may be used to extend or expand upon doctoral work, it must be made clear that you are not intending to use the award to wrap up a thesis. While it is expected that a postdoctoral fellow will be taking the next step beyond the PhD thesis, you must differentiate clearly between the postdoctoral project and the thesis research. Feel free to include hyperlinks to provide links to additional information.

As applicants must make UBC their base, it is important -- particularly for applicants whose primary research materials are elsewhere -- to indicate what travel is involved, to where, and for how long. You should describe how you will deal with the remoteness of the primary materials.

The adjudication committee is very interested in "fit" with the selected UBC department or unit and the university's research programs. You must provide information on how your research relates to that of specific campus programs and advisors. If a colloquium is envisioned, a possible title should be proposed. If you will visit in classes, please suggest which ones. Since inter-disciplinarity is often a valuable dimension (the Killam Trusts declares that a candidate shall not be "a one-sided person"), specific details on proposed inter-departmental connections are welcome.
