---
layout: archive
title: List of Issued CVE's
breadcrumbs: true
---

<table>
  <thead>
    <tr>
      <th>Summary</th>
      <th>Publication</th>
      <th>CVE ID</th>
      <th>Published Date</th>
      <th>Last Updated</th>
    </tr>
  </thead>
  <tbody>
    <!-- TODO: Remove Test CVEs -->
    {% for cve in site.data.cves %}
      <tr>
        <td>
          <a href="{{ site.baseurl }}/cves/{{ cve[0] | downcase }}.html">
            {{ cve[1].containers.cna.title }}
          </a>
        </td>
        <td>
          <ul>
            {% for publication in cve[1].containers.cna.affected %}
              <li>
                {% case publication.collectionURL %}
                  {% when "https://repo.hex.pm" %}
                    Hex: <code>{{ publication.packageName }}</code>
                  {% when "https://github.com" %}
                    GitHub: <code>{{ publication.packageName }}</code>
                  {% else %}
                    {{ publication.vendor }} {{ publication.product }}
                {% endcase %}
              </li>
            {% endfor %}
          </ul>
        </td>
        <td>
          <a href="{{ site.baseurl }}/cves/{{ cve[0] | downcase }}.html">
            {{ cve[0] }}
          </a>
        </td>
        <td>{{ cve[1].cveMetadata.datePublished | date_to_long_string }}</td>
        <td>{{ cve[1].cveMetadata.dateUpdated | date_to_long_string }}</td>
      </tr>
    {% endfor %}
  </tbody>
</table>