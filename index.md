---
title: Erlang Ecosystem Foundation CNA
layout: page
---

<p class="lead">
  The Erlang Ecosystem Foundation CNA is a collaborative effort to assign and
  maintain CVE identifiers within the ecosystem, providing a consistent and
  transparent process for reporting, documenting, and mitigating security
  vulnerabilities.
</p>

{% include ecosystem-logos.html %}

As a [CNA (CVE Numbering Authority)](https://www.cve.org/programorganization/cnas),
we assign CVE IDs for vulnerabilities in active packages hosted on
[Hex.pm](https://hex.pm/) and in projects under the GitHub organizations listed
in our [scope](./scope). All CVEs are also published to [OSV.dev](https://osv.dev/).
This CNA is hosted by the
[Erlang Ecosystem Foundation's Security Working Group](https://erlef.org/wg/security).

## CVE Activity

<div class="cve-chart-wrapper">
  {%- include cve-chart.svg -%}
</div>
<p class="text-muted" style="font-size:0.875rem;margin-top:0.5rem;">CVEs published by quarter since the CNA was established.</p>

## Latest CVEs

<div class="row cve-list">
  {% assign sorted_cves = site.data.cves | sort_cves_by_date %}
  {% for cve in sorted_cves limit:3 %}
    <div class="col-12 col-lg-4 mb-3 mb-lg-0">
      <a href="{{ site.baseurl }}/cves/{{ cve[0] }}.html" class="cve-item">
        <div class="cve-header">
          <span class="cve-id">{{ cve[0] }}</span>
          <span class="cve-date">{{ cve[1].cveMetadata.datePublished | date: "%b %d, %Y" }}</span>
        </div>
        <div class="cve-title">{{ cve[1].containers.cna.title }}</div>
        <div class="cve-package">{{ cve[1].containers.cna.affected[0].packageURL | split: "?" | first }}</div>
      </a>
    </div>
  {% endfor %}
</div>

<p class="mt-3">
  <a href="./cves/" class="btn btn-outline-primary">View All CVEs</a>
</p>

## Resources

<div class="resource-grid">
  <a href="./scope" class="resource-card">
    <i class="fas fa-crosshairs"></i>
    <strong>CNA Scope</strong>
    <span>What projects we cover</span>
  </a>
  <a href="./contact" class="resource-card">
    <i class="fas fa-envelope"></i>
    <strong>Contact</strong>
    <span>Report a vulnerability</span>
  </a>
  <a href="./cve-criteria" class="resource-card">
    <i class="fas fa-clipboard-check"></i>
    <strong>CVE Criteria</strong>
    <span>Assignment guidelines</span>
  </a>
  <a href="./security-policy" class="resource-card">
    <i class="fas fa-book"></i>
    <strong>Security Policy</strong>
    <span>Disclosure process</span>
  </a>
  <a href="./data-licensing" class="resource-card">
    <i class="fas fa-balance-scale"></i>
    <strong>Data Licensing</strong>
    <span>License information</span>
  </a>
</div>
