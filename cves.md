---
layout: page
title: List of Issued CVE's
breadcrumbs: true
---

<div class="table-responsive">
  <table class="table table-striped table-bordered">
    <thead class="thead-dark">
      <tr>
        <th scope="col">Summary</th>
        <th scope="col">Publication</th>
        <th scope="col">CVE ID</th>
        <th scope="col">Published Date</th>
        <th scope="col">Last Updated</th>
      </tr>
    </thead>
    <tbody>
      <!-- TODO: Remove Test CVEs -->
      {% for cve in site.data.cves %}
        <tr>
          <th scope="row">
            <a href="{{ site.baseurl }}/cves/{{ cve[0] | downcase }}.html">
              {{ cve[1].containers.cna.title }}
            </a>
          </th>
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
</div>