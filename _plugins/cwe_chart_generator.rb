module Jekyll
  class CweChartGenerator < Generator
    safe false
    priority :low

    R_OUTER = 160
    R_INNER = 90
    MARGIN  = 10   # padding around the donut in the SVG viewBox
    FONT    = "system-ui,-apple-system,'Segoe UI',sans-serif"

    COLORS = %w[
      #6610f2 #0d6efd #198754 #dc3545 #fd7e14 #ffc107
      #20c997 #0dcaf0 #6f42c1 #d63384 #adb5bd #495057
    ].freeze

    def generate(site)
      cves        = site.data["cves"] || {}
      cwe_classes = site.data["cwe_classes"] || {}

      raw     = aggregate(cves, cwe_classes)
      total   = raw.sum { |_, v| v }.to_f
      entries = build_entries(raw)

      svg_dest    = File.join(site.source, "_includes", "cwe-chart.svg")
      legend_dest = File.join(site.source, "_includes", "cwe-legend.html")

      File.write(svg_dest,    build_svg(entries, raw, total))
      File.write(legend_dest, build_legend(entries, total))
    end

    private

    def aggregate(cves, cwe_classes)
      counts = Hash.new(0)
      cves.each do |_id, rec|
        problem_types = rec.dig("containers", "cna", "problemTypes") || []
        cwe_ids = problem_types.flat_map { |pt| pt["descriptions"] || [] }
                               .select   { |d| d["cweId"] }
                               .map      { |d| d["cweId"] }
                               .uniq

        class_ids = cwe_ids.map { |id| cwe_classes[id] || { "id" => id, "name" => id } }
                           .uniq { |c| c["id"] }
        class_ids.each { |c| counts[[c["id"], c["name"]]] += 1 }
      end
      counts.sort_by { |_, v| -v }
    end

    def build_entries(raw)
      # Show up to 12 slices with at least 2 CVEs; fold the rest into "Other"
      main        = raw.select { |_, v| v >= 2 }.first(12)
      other_count = (raw - main).sum { |_, v| v }
      entries     = main
      entries    << [["Other", "Other CWE types"], other_count] if other_count > 0
      entries
    end

    def arc_path(cx, cy, r_outer, r_inner, start_angle, end_angle)
      sweep     = end_angle - start_angle
      sweep     = sweep >= 2 * Math::PI ? 2 * Math::PI - 0.0001 : sweep
      end_angle = start_angle + sweep

      cos_s = Math.cos(start_angle); sin_s = Math.sin(start_angle)
      cos_e = Math.cos(end_angle);   sin_e = Math.sin(end_angle)

      ox1 = (cx + r_outer * cos_s).round(3); oy1 = (cy + r_outer * sin_s).round(3)
      ox2 = (cx + r_outer * cos_e).round(3); oy2 = (cy + r_outer * sin_e).round(3)
      ix1 = (cx + r_inner * cos_e).round(3); iy1 = (cy + r_inner * sin_e).round(3)
      ix2 = (cx + r_inner * cos_s).round(3); iy2 = (cy + r_inner * sin_s).round(3)

      large = sweep > Math::PI ? 1 : 0
      "M #{ox1} #{oy1} A #{r_outer} #{r_outer} 0 #{large} 1 #{ox2} #{oy2} " \
      "L #{ix1} #{iy1} A #{r_inner} #{r_inner} 0 #{large} 0 #{ix2} #{iy2} Z"
    end

    def build_popover(mid_angle, label, count, total, cx, cy, size)
      pct  = ((count / total) * 100).round(1)
      text = "#{label}: #{count} CVE#{count == 1 ? '' : 's'} (#{pct}%)"
      tw   = (text.length * 6.3 + 16).round
      th   = 26

      ar = R_OUTER + 16
      ax = (cx + ar * Math.cos(mid_angle)).round(1)
      ay = (cy + ar * Math.sin(mid_angle)).round(1)

      bx = (ax - tw / 2.0).clamp(2, size - tw - 2).round(1)
      by = (ay - th - 4).round(1)
      by = (ay + 4).round(1)          if by < 2
      by = [by, size - th - 2].min.round(1)

      <<~SVG.chomp
        <g class="cwe-popover" aria-hidden="true">
          <rect x="#{bx}" y="#{by}" width="#{tw}" height="#{th}" rx="4" fill="#fff" stroke="#dee2e6" stroke-width="1"/>
          <text x="#{bx + tw / 2}" y="#{by + 17}" text-anchor="middle" font-size="11" font-family="#{FONT}" fill="#212529">#{text}</text>
        </g>
      SVG
    end

    # ── SVG: donut only ───────────────────────────────────────────────────────

    def build_svg(entries, raw, total)
      size = (R_OUTER + MARGIN) * 2   # square viewBox
      cx   = size / 2
      cy   = size / 2

      slices = []
      angle  = -Math::PI / 2
      entries.each_with_index do |(key, count), idx|
        sweep     = (count / total) * 2 * Math::PI
        end_angle = angle + sweep
        slices << {
          color:     COLORS[idx % COLORS.size],
          d:         arc_path(cx, cy, R_OUTER, R_INNER, angle, end_angle),
          mid_angle: angle + sweep / 2,
          cwe_id:    key.is_a?(Array) ? key[0] : key,
          count:     count,
        }
        angle = end_angle
      end

      lines = []
      lines << %(<svg viewBox="0 0 #{size} #{size}" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="CWE distribution donut chart" style="width:100%;height:auto;display:block;">)
      lines << "  <title>Common Weakness Distribution</title>"

      # Pass 1: solid slices
      slices.each do |s|
        lines << %(<path d="#{s[:d]}" fill="#{s[:color]}" stroke="#fff" stroke-width="2"/>)
      end

      # Centre label
      lines << %(<text x="#{cx}" y="#{cy - 10}" text-anchor="middle" font-size="13" font-family="#{FONT}" fill="#6c757d">Total</text>)
      lines << %(<text x="#{cx}" y="#{cy + 14}" text-anchor="middle" font-size="28" font-weight="600" font-family="#{FONT}" fill="#212529">#{raw.sum { |_, v| v }}</text>)
      lines << %(<text x="#{cx}" y="#{cy + 33}" text-anchor="middle" font-size="12" font-family="#{FONT}" fill="#6c757d">CVEs</text>)

      # Pass 2: hit-targets + popovers on top
      slices.each do |s|
        lines << %(<g class="cwe-slice-group" tabindex="0">)
        lines << %(  <path d="#{s[:d]}" fill="transparent" stroke="none" class="cwe-slice-hit"/>)
        lines << build_popover(s[:mid_angle], s[:cwe_id], s[:count], total, cx, cy, size)
        lines << %(</g>)
      end

      lines << "</svg>"
      lines.join("\n") + "\n"
    end

    # ── HTML legend ───────────────────────────────────────────────────────────

    def build_legend(entries, total)
      rows = entries.map.with_index do |(key, count), idx|
        cwe_id = key.is_a?(Array) ? key[0] : key
        desc   = key.is_a?(Array) ? key[1] : key
        color  = COLORS[idx % COLORS.size]
        pct    = ((count / total) * 100).round(1)
        num    = cwe_id.sub("CWE-", "")
        href   = cwe_id == "Other" ? nil : "https://cwe.mitre.org/data/definitions/#{num}.html"

        short_desc = desc.gsub(/^CWE-\d+\s+/, "")

        id_html   = %(<span class="cwe-legend-id" style="color:#{color};">#{cwe_id}</span>)
        desc_html = cwe_id == "Other" ? "" : %(<span class="cwe-legend-desc">#{short_desc}</span>)

        if href
          id_html   = %(<a href="#{href}" target="_blank" rel="noopener" class="cwe-legend-link">#{id_html}</a>)
          desc_html = %(<a href="#{href}" target="_blank" rel="noopener" class="cwe-legend-link">#{desc_html}</a>) unless desc_html.empty?
        end

        <<~HTML.chomp
          <tr>
            <td class="cwe-legend-swatch-cell"><span class="cwe-legend-swatch" style="background:#{color};"></span></td>
            <td class="cwe-legend-id-cell">#{id_html}</td>
            <td class="cwe-legend-desc-cell">#{desc_html}</td>
            <td class="cwe-legend-count-cell">#{count}<span class="cwe-legend-pct"> (#{pct}%)</span></td>
          </tr>
        HTML
      end

      <<~HTML
        <table class="cwe-legend-table" aria-label="CWE class legend">
          <tbody>
            #{rows.join("\n    ")}
          </tbody>
        </table>
      HTML
    end
  end
end