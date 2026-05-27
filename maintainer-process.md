---
layout: page_with_toc
title: Maintainer Process
breadcrumbs: true
---

<p class="lead">
  This page explains how coordinated disclosure works when the EEF CNA is involved,
  whether we reached out to you or you came to us with a report from a third party.
</p>

## 1. How You May Be Contacted

### 1.1 The CNA Contacts You

If we have received a vulnerability report concerning your project, we will reach out to
you directly. You can expect a personal email from one of our Points of Contact, or an
invitation to a **GitHub Security Advisory** on your repository.

Our initial message will include:

- A summary of the reported vulnerability
- The CVE ID we have reserved (or a note that we will assign one)
- A request to confirm your preferred coordination channel (GitHub Advisory or email)

### 1.2 You Contact the CNA

If you have received a vulnerability report from a third party and need a CVE number,
please reach out to us via our [Contact](/contact) page. We will acknowledge your report
within **two business days** and guide you through the rest of the process.

## 2. Preferred Channel: GitHub Private Vulnerability Reporting

We strongly recommend using [GitHub Private Vulnerability Reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
for coordinating disclosure. It keeps all communication, patches, and timelines in one
place, and makes it easy to collaborate privately.

<div class="steps-container">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <strong>Enable Private Vulnerability Reporting</strong>
      <p>
        In your GitHub repository, go to <em>Settings &rarr; Security &amp; quality</em> and
        enable <em>Private vulnerability reporting</em>.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <strong>Invite the CNA as Collaborators</strong>
      <p>Add our Points of Contact to the private advisory so we can assist with triage, assign the CVE ID, and coordinate publication.</p>
      <ul class="collaborator-list">
        {% for member in site.data.team %}
          <li><code>@{{ member.github }}</code> <span>{{ member.name }} – {{ member.affiliation }}</span></li>
        {% endfor %}
      </ul>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <strong>Set the CVE ID Field</strong>
      <p>
        When creating the advisory, choose <em>"Request CVE ID later"</em>. Once we
        provide the CVE ID, edit the advisory and select <em>"I have an existing CVE ID"</em>.
      </p>
    </div>
  </div>
</div>

## 3. Email Alternative

If your project is not hosted on GitHub, or you prefer email, you can coordinate
everything through **cna@erlef.org**. Encrypted communication is also supported; see
the [Contact page](/contact) for our GPG key and fingerprint.

## 4. The Disclosure Process

Once initial contact is established, the typical workflow is as follows:

<div class="steps-container">
  <div class="step-card">
    <div class="step-number">1</div>
    <div class="step-content">
      <strong>Triage</strong>
      <p>Review the advisory or report. Confirm the issue is valid and assess its severity.</p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">2</div>
    <div class="step-content">
      <strong>Add Reporters as Collaborators</strong>
      <p>
        Invite the original reporters to your private advisory. They can clarify details
        and verify that your patch addresses the issue.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">3</div>
    <div class="step-content">
      <strong>Set the CVE ID</strong>
      <p>
        We will provide you with a CVE ID. In the advisory, go to
        <em>Edit</em> &rarr; <em>CVE identifier</em> &rarr; <em>I have an existing CVE ID</em>
        and enter the ID we give you. Do <b style="display:inline">not</b> request a CVE ID from GitHub.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">4</div>
    <div class="step-content">
      <strong>Create a Private Fork</strong>
      <p>
        Use GitHub's <em>"Start a temporary private fork"</em> button on the advisory page.
        All patch development should happen in this private fork, not on your public
        repository. If you are coordinating via email, you can also send the patch as an
        attachment or inline diff instead.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">5</div>
    <div class="step-content">
      <strong>Develop the Patch</strong>
      <p>
        Push your fix to the private fork and open a Pull Request there. Do not push
        security-related changes to main or any public branch. Include the GHSA ID and
        CVE ID in your commit message.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">6</div>
    <div class="step-content">
      <strong>Review &amp; Test</strong>
      <p>
        Reporters test the patch and provide feedback. Iterate privately until everyone
        is satisfied with the fix. In parallel, the CNA will fill in the advisory details:
        <a href="https://cwe.mitre.org/">CWE</a> (weakness type),
        <a href="https://www.first.org/cvss/">CVSS</a> (severity score), credits, and
        the public description.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">7</div>
    <div class="step-content">
      <strong>Coordinate Release Date</strong>
      <p>
        Agree on a publication date with the CNA. We appreciate a heads-up so we can
        be ready to publish the CVE promptly.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">8</div>
    <div class="step-content">
      <strong>Merge &amp; Release</strong>
      <p>
        Merge the private PR, and publish a new release to Hex.pm (or your relevant
        registry). Do this only on the agreed date.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">9</div>
    <div class="step-content">
      <strong>Publish the Advisory</strong>
      <p>
        Publish the GitHub Security Advisory. This makes the vulnerability details
        publicly visible.
      </p>
    </div>
  </div>
  <div class="step-card">
    <div class="step-number">10</div>
    <div class="step-content">
      <strong>CNA Publishes the CVE</strong>
      <p>
        Once the advisory is published, we will publish the CVE to
        <a href="https://www.cve.org/">CVE.org</a>, <a href="https://osv.dev/">OSV.dev</a>,
        and <a href="https://hex.pm/">Hex.pm</a>.
      </p>
    </div>
  </div>
</div>

## 5. Timelines &amp; Embargo

<div class="warning-box">
  <i class="fas fa-exclamation-triangle"></i>
  <span>
    <strong>Do not make anything public before the advisory is published.</strong>
    This includes public Pull Requests, commits to main, public issues, blog posts,
    social media posts, or any other public communication referencing the vulnerability.<br><br>
    <strong>If information becomes public, our disclosure timeline immediately shifts
    to 24 hours or less</strong>, regardless of whether a patch is ready.
  </span>
</div>

Key timeframes:

- **Maximum embargo:** 3 months from the date we first contact you.
- **Non-response:** If we do not receive a response within **14 days**, we may proceed with
  publishing the CVE unilaterally.
- **Active exploitation:** If we become aware that the vulnerability is being actively
  exploited in the wild, we will publish within **24 hours**, regardless of patch status.
- **Coordination period:** We aim to be as flexible as possible, but all timelines are
  bounded by our [Security Policy](/security-policy).

Please remain reachable throughout the process. We will always try to give you a
heads-up before we publish.

## 6. What Not to Do

The following actions break the embargo and can cause the CVE to be published
immediately, even if no patch is available:

- Opening a public Pull Request that references or fixes the vulnerability
- Merging a security fix to `main` or any public branch before the advisory is published
- Including the CVE ID or vulnerability details in a public commit message
- Discussing the issue in a public GitHub issue or discussion
- Announcing a "security release" before the advisory is ready
- Posting about the vulnerability on social media, a blog, or a mailing list

## 7. Further Resources

<div class="resource-grid">
  <a href="/contact" class="resource-card">
    <i class="fas fa-envelope"></i>
    <strong>Contact</strong>
    <span>Reach out to the CNA</span>
  </a>
  <a href="/cve-criteria" class="resource-card">
    <i class="fas fa-clipboard-check"></i>
    <strong>CVE Criteria</strong>
    <span>What qualifies for a CVE</span>
  </a>
  <a href="/security-policy" class="resource-card">
    <i class="fas fa-book"></i>
    <strong>Security Policy</strong>
    <span>Full disclosure policy &amp; timelines</span>
  </a>
  <a href="https://security.erlef.org/security_vulnerability_disclosure/" class="resource-card">
    <i class="fas fa-shield-alt"></i>
    <strong>EEF Security WG Guide</strong>
    <span>Vulnerability handling best practices</span>
  </a>
</div>
