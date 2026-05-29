---
layout: page_with_toc
title: Coordinator Process
breadcrumbs: true
---

<p class="lead">
  With an unprecedented wave of vulnerability reports, we need help. If you have
  security knowledge and want to contribute to a safer Erlang ecosystem, this page
  is for you.
</p>

## 1. Support the CNA

Running a CNA takes time and resources. There are two ways to help:

- **Financially:** The EEF depends on sponsors to fund this work.
  Consider [sponsoring the EEF](https://erlef.org/sponsors).
- **As a volunteer coordinator:** Handle reports, triage vulnerabilities, and
  coordinate disclosures with maintainers. Read on to find out how.

## 2. Sign Up as a Coordinator

<div class="steps-container">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <strong>Join the EEF and its Slack</strong>
      <p>
        <a href="https://members.erlef.org/join-us">Become an EEF member</a> and join
        the community Slack workspace.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <strong>Announce yourself on #cna-public</strong>
      <p>
        Use the <em>"Sign Up as a CNA Coordinator"</em> workflow in the
        <code>#cna-public</code> Slack channel to let us know you want to help.
      </p>
      {% include step-screenshot.html src="assets/img/coordinator-process/slack-workflows.png" alt="Slack channel showing Reserve a CVE ID and Sign Up as a CNA Coordinator workflow buttons" %}
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <strong>Tell us your specialities</strong>
      <p>
        Domain knowledge is valuable. If you know the details and RFCs around SSH,
        TLS, cryptography, or any other area, let us know. It helps us route reports
        to the right people.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">4</div>
    <div class="step-content">
      <strong>Share your contact details</strong>
      <p>Tell us your email address and GitHub handle so we can reach you privately.</p>
    </div>
  </div>
</div>

## 3. Working with People

The technical side of coordination is learnable. The human side is often harder.

Receiving a CVE report is stressful for most maintainers. Open source projects are
frequently personal labours of love, and a security vulnerability can feel like a
public indictment. Many maintainers will be genuinely grateful for your help, but
others may react with anxiety, defensiveness, or even hostility. Shame is common.
People under stress make hasty decisions, sometimes exactly the kind that break the
embargo.

Your job is not just to communicate facts, but to help maintainers get grounded and
make good decisions. Some things that help:

- Acknowledge that receiving this kind of report is hard.
- Be clear that the goal is to protect their users, not to criticise their work.
- Explain the process and timelines calmly and early, so there are no surprises.
- When a maintainer is moving too fast or about to do something risky, slow them down
  rather than just flagging the problem.

If a maintainer lashes out, stay friendly and professional. Do not match their tone.

If communication is repeatedly going in a bad direction and you are not able to get
things back on track, involve a CNA Point of Contact before anything escalates. Do
not let a difficult conversation drag on without support.

## 4. Required Knowledge

You do not need to know everything upfront, but these are the core concepts you will
work with on every report.

- **[CVSS v4.0](https://www.first.org/cvss/v4.0/user-guide):** Every vulnerability is
  scored using CVSS. This measures severity across dimensions like attack vector,
  complexity, and impact. Read the user guide before handling your first report.

- **[CWE](https://cwe.mitre.org/about/new_to_cwe.html):** Every vulnerability is
  classified by weakness type using CWE (Common Weakness Enumeration). For example,
  CWE-79 is Cross-site Scripting and CWE-22 is Path Traversal.

- **[CAPEC](https://capec.mitre.org/about/new_to_capec.html):** Every vulnerability is
  assigned an attack pattern using CAPEC (Common Attack Pattern Enumeration and
  Classification). This describes how an attacker would exploit the weakness.

- **[Package URL](https://packageurl.org/):** Affected software is identified using
  Package URLs (purl). For example, `pkg:hex/phoenix` identifies the `phoenix` package
  on Hex.pm.

## 5. Before Your First Report

Take some time to get familiar with how our CVE records look in practice. Browse the
[published CVEs](/cves) on this site to see the level of detail we include in titles,
descriptions, affected version ranges, and credits.

For the underlying data format, refer to the
[CVE JSON schema](https://github.com/CVEProject/cve-schema). All our records follow
this schema, and the [cna-staging repository](https://github.com/erlef-cna/cna-staging)
contains tooling to validate and format them.
[Vulnogram](https://vulnogram.github.io/) is a useful tool for visually editing and
validating CVE JSON records.

## 6. The Coordination Process

<div class="steps-container">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <strong>Receive the Report</strong>
      <p>
        We will contact you privately with a vulnerability report. Treat all details
        as confidential until the advisory is published.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <strong>Triage</strong>
      <p>
        Determine whether the report warrants a CVE. Check our
        <a href="/cve-criteria">CVE Criteria</a> page for guidance.
      </p>
      <ul>
        <li><strong>If yes:</strong> use the <em>"Reserve a CVE ID"</em> workflow in <code>#cna-public</code> on Slack, or ask a CNA Point of Contact directly.</li>
        <li><strong>If no:</strong> it may still be a bug worth reporting. Open an issue
        or send a PR to the affected project instead.</li>
      </ul>
      {% include step-screenshot.html src="assets/img/coordinator-process/slack-workflows.png" alt="Slack channel showing Reserve a CVE ID and Sign Up as a CNA Coordinator workflow buttons" %}
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <strong>Find Contact Information</strong>
      <p>Work through these options in order to find how to reach the maintainer:</p>
      <ul>
        <li>Check for a <code>SECURITY.md</code> file in the repository.</li>
        <li>Check if GitHub Private Vulnerability Reporting is enabled.</li>
        <li>Look for an email on the Hex.pm user profile or GitHub profile.</li>
        <li>If no email is public, check the git log; commit author emails are often
        available there.</li>
      </ul>
      <p>When coordinating via email, always CC <strong>cna@erlef.org</strong> on all communications.</p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">4</div>
    <div class="step-content">
      <strong>Write a Proof of Concept</strong>
      <p>
        Demonstrate that the vulnerability actually exists with a minimal reproducible
        example. This confirms the report is valid and gives the maintainer something
        concrete to work with, and it also informs accurate CVSS scoring.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">5</div>
    <div class="step-content">
      <strong>Assess CVSS, CWE, and Affected Versions</strong>
      <p>
        Score the vulnerability using CVSS v4.0, identify the CWE weakness type, and
        determine which version ranges are affected.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">6</div>
    <div class="step-content">
      <strong>Report to the Maintainer</strong>
      <p>Your report should include:</p>
      <ul>
        <li>A description of the vulnerability</li>
        <li>The proof of concept</li>
        <li>The CVE ID</li>
        <li>CVSS score and CWE classification</li>
        <li>Affected packages and version ranges (including any related artifacts such
        as Docker images)</li>
        <li>A link to the <a href="/maintainer-process">Maintainer Process</a> page</li>
      </ul>
      <p>If you have a patch ready, include it as well.</p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">7</div>
    <div class="step-content">
      <strong>Coordinate with the Maintainer</strong>
      <p>
        Work with the maintainer to get a patch written, reviewed, and a release date
        agreed. Refer them to the <a href="/maintainer-process">Maintainer Process</a>
        page for step-by-step guidance.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">8</div>
    <div class="step-content">
      <strong>Prepare the Public Summary</strong>
      <p>
        The initial report contained full details including a proof of concept. The
        public advisory should be concise. Write a public-facing summary following the
        <a href="https://docs.github.com/en/code-security/security-advisories/working-with-global-security-advisories-from-the-github-advisory-database/about-the-github-advisory-database">GitHub Advisory</a>
        format: a short description of the vulnerability, its impact, and the affected
        versions. Leave out exploit details and internal investigation notes. See
        <a href="https://github.com/ex-aws/ex_aws_sns/security/advisories/GHSA-8jgf-23q5-x7xx">this advisory</a>
        as an example.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">9</div>
    <div class="step-content">
      <strong>Observe Timelines</strong>
      <p>Keep these timeframes in mind throughout the process:</p>
      <ul>
        <li><strong>Publicly known or actively exploited vulnerabilities:</strong> publish
        within 24 hours.</li>
        <li><strong>New reports:</strong> contact the maintainer within 2 business days.</li>
        <li><strong>Maximum embargo:</strong> 3 months from the initial report.</li>
        <li><strong>Maintainer non-response:</strong> if there is no reply within 1 week,
        follow up via alternative channels. If there is still no response after 14 days,
        we will publish without maintainer involvement.</li>
      </ul>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">10</div>
    <div class="step-content">
      <strong>Prepare the CVE Record</strong>
      <p>
        Prepare the CVE JSON record and send it to the CNA Points of Contact privately
        for review before publication.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">11</div>
    <div class="step-content">
      <strong>Trigger Publication</strong>
      <p>
        Once the maintainer has merged the fix, released a new version, and published
        the advisory, notify the CNA Points of Contact to publish the CVE.
      </p>
    </div>
  </div>
</div>

## 7. CNA Internal Process & Tooling

The internal CNA workflow is documented in the
[cna-staging repository](https://github.com/erlef-cna/cna-staging). This includes
scripts for formatting and validating CVE records, converting to OSV format, and
automation workflows.

The repository also contains a set of Claude Code skills that can assist with
common coordinator tasks:

- [new-cve](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/new-cve/SKILL.md): step-by-step workflow for creating a CVE record
- [cvss](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/cvss/SKILL.md): CVSS v4.0 scoring
- [find-cwe](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/find-cwe/SKILL.md): CWE classification
- [find-capec](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/find-capec/SKILL.md): CAPEC attack pattern identification
- [find-intro-commit](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/find-intro-commit/SKILL.md): locate the commit that introduced a vulnerability
- [summarize-cve](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/summarize-cve/SKILL.md): generate a technical CVE summary
- [verify](https://github.com/erlef-cna/cna-staging/blob/main/.claude/skills/verify/SKILL.md): validate a CVE record before submission

<div class="warning-box" style="margin-bottom:1.5rem;">
  <i class="fas fa-exclamation-triangle"></i>
  <span>
    AI can be very helpful for these tasks, but every result must be verified by a human
    before submission. Do not rely on AI output without checking it yourself.
  </span>
</div>

## 8. Further Resources

<div class="resource-grid">
  <a href="/contact" class="resource-card">
    <i class="fas fa-envelope"></i>
    <strong>Contact</strong>
    <span>Reach the CNA Points of Contact</span>
  </a>
  <a href="/cve-criteria" class="resource-card">
    <i class="fas fa-clipboard-check"></i>
    <strong>CVE Criteria</strong>
    <span>What qualifies for a CVE</span>
  </a>
  <a href="/maintainer-process" class="resource-card">
    <i class="fas fa-code-branch"></i>
    <strong>Maintainer Process</strong>
    <span>Share this with maintainers</span>
  </a>
  <a href="/security-policy" class="resource-card">
    <i class="fas fa-book"></i>
    <strong>Security Policy</strong>
    <span>Full disclosure policy &amp; timelines</span>
  </a>
  <a href="https://www.first.org/cvss/v4.0/user-guide" class="resource-card">
    <i class="fas fa-tachometer-alt"></i>
    <strong>CVSS v4.0 User Guide</strong>
    <span>Learn to score vulnerabilities</span>
  </a>
  <a href="https://cwe.mitre.org/about/new_to_cwe.html" class="resource-card">
    <i class="fas fa-tag"></i>
    <strong>New to CWE</strong>
    <span>Learn weakness classification</span>
  </a>
  <a href="https://capec.mitre.org/about/new_to_capec.html" class="resource-card">
    <i class="fas fa-user-secret"></i>
    <strong>New to CAPEC</strong>
    <span>Learn attack pattern classification</span>
  </a>
  <a href="https://packageurl.org/" class="resource-card">
    <i class="fas fa-box"></i>
    <strong>Package URL</strong>
    <span>Package identifier format</span>
  </a>
  <a href="https://github.com/CVEProject/cve-schema" class="resource-card">
    <i class="fas fa-file-code"></i>
    <strong>CVE JSON Schema</strong>
    <span>Official CVE record format</span>
  </a>
  <a href="https://vulnogram.github.io/" class="resource-card">
    <i class="fas fa-edit"></i>
    <strong>Vulnogram</strong>
    <span>Visual CVE JSON editor</span>
  </a>
</div>
