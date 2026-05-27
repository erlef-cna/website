---
layout: page
title: Contact
breadcrumbs: true
---

<p class="lead">
  We encourage security researchers and members of the community to report
  vulnerabilities through the following contact methods.
</p>

<div class="warning-box" style="margin-bottom:1.5rem;">
  <i class="fas fa-code-branch"></i>
  <span>Are you a project maintainer coordinating a disclosure with us? See the <a href="/maintainer-process">Maintainer Process</a> page for step-by-step guidance.</span>
</div>

## Report a Vulnerability

<div class="contact-grid">
  <a href="mailto:cna@erlef.org" class="contact-card">
    <i class="fas fa-envelope"></i>
    <strong>Email</strong>
    <span>cna@erlef.org</span>
  </a>
  <a href="https://keys.openpgp.org/vks/v1/by-fingerprint/38BD201B397E28F1F3D93EC76E031A811F266E21" class="contact-card">
    <i class="fas fa-key"></i>
    <strong>GPG Key</strong>
    <span>For encrypted communications</span>
  </a>
</div>

<div class="gpg-fingerprint" style="margin-bottom:1.5rem;">
  <strong>Fingerprint:</strong> <code>38BD 201B 397E 28F1 F3D9 3EC7 6E03 1A81 1F26 6E21</code>
</div>


## Team

<div class="content-box" style="margin-bottom:1.5rem;">
  <ul class="collaborator-list" style="margin:0;">
    {% for member in site.data.team %}
      <li>
        <code>@{{ member.github }}</code>
        <span>{{ member.name }} – {{ member.affiliation }}</span>
        {% if member.primary_poc %}<span class="poc-badge">Primary PoC</span>{% endif %}
      </li>
    {% endfor %}
  </ul>
</div>

## Questions & Suggestions

<div class="contact-grid">
  <a href="https://github.com/orgs/erlef-cna/discussions" class="contact-card">
    <i class="fab fa-github"></i>
    <strong>GitHub Discussions</strong>
    <span>For general questions</span>
  </a>
</div>

<div class="warning-box">
  <i class="fas fa-exclamation-triangle"></i>
  <span>GitHub Discussions are public. Never report or include vulnerability details.</span>
</div>
