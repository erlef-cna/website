module Jekyll
  class CveChartGenerator < Generator
    safe false
    priority :low

    # Chart geometry constants
    VIEW_W      = 700
    VIEW_H      = 260
    LEFT        = 50
    TOP         = 20
    WIDTH       = 620
    HEIGHT      = 180
    BOTTOM      = TOP + HEIGHT
    RIGHT       = LEFT + WIDTH
    FONT        = "system-ui,-apple-system,'Segoe UI',sans-serif"
    COLOR       = "#6610f2"
    AXIS_COLOR  = "#6c757d"
    GRID_COLOR  = "#e9ecef"

    def generate(site)
      cves = site.data["cves"] || {}
      svg  = build_svg(cves)

      # Write to _includes so {% include cve-chart.svg %} works
      dest = File.join(site.source, "_includes", "cve-chart.svg")
      File.write(dest, svg)
    end

    private

    # ------------------------------------------------------------------ data

    def aggregate(cves)
      counts = Hash.new(0)
      cves.each do |_id, rec|
        date_str = rec.dig("cveMetadata", "datePublished")
        next unless date_str&.match?(/\A\d{4}-\d{2}/)
        year  = date_str[0, 4].to_i
        month = date_str[5, 2].to_i
        counts["#{year}-Q#{((month - 1) / 3) + 1}"] += 1
      end
      counts
    end

    def current_quarter_info
      now          = Time.now.utc
      year         = now.year
      q            = ((now.month - 1) / 3) + 1
      start_month  = (q - 1) * 3 + 1
      q_start      = Time.utc(year, start_month, 1)
      end_month    = start_month + 3
      q_end        = end_month > 12 ? Time.utc(year + 1, 1, 1) : Time.utc(year, end_month, 1)
      total_days   = (q_end - q_start).to_f / 86400
      elapsed_days = [(now - q_start).to_f / 86400, 1].max
      progress     = (elapsed_days / total_days).clamp(0.01, 1.0)
      { key: "#{year}-Q#{q}", progress: progress }
    end

    def build_points(cves)
      counts   = aggregate(cves)
      cur_info = current_quarter_info
      cur_key  = cur_info[:key]
      progress = cur_info[:progress]

      sorted_keys    = counts.keys.sort
      completed_keys = sorted_keys.reject { |k| k == cur_key }

      raw_count       = counts[cur_key] || 0
      projected_count = (raw_count / progress).round

      # Next quarter: linear regression over the last 3 completed quarters + projected
      # current, extrapolated one step forward. Limiting to recent quarters avoids early
      # low values diluting the current upward trend.
      recent_keys = completed_keys.last(3)
      regression_points = recent_keys.each_with_index.map { |k, i| [i, counts[k].to_f] }
      regression_points << [regression_points.size, projected_count.to_f]

      next_count = if regression_points.size >= 2
        n    = regression_points.size
        xs   = regression_points.map(&:first)
        ys   = regression_points.map(&:last)
        x_mean = xs.sum.to_f / n
        y_mean = ys.sum.to_f / n
        num  = xs.zip(ys).sum { |x, y| (x - x_mean) * (y - y_mean) }
        den  = xs.sum { |x| (x - x_mean)**2 }
        slope     = den.zero? ? 0 : num / den
        intercept = y_mean - slope * x_mean
        predicted = slope * n + intercept  # index n = one step past last point
        [predicted.round, 0].max
      else
        projected_count
      end

      cur_year = cur_key.split("-Q").first.to_i
      cur_q    = cur_key.split("-Q").last.to_i
      next_q   = cur_q == 4 ? 1   : cur_q + 1
      next_yr  = cur_q == 4 ? cur_year + 1 : cur_year

      all_values = counts.values + [projected_count, next_count]
      y_max      = [((all_values.max / 5.0).ceil * 5), 5].max

      # Prepend a zero-count quarter before the first real data point
      first_key   = sorted_keys.first
      first_yr, first_q = first_key.split("-Q").map(&:to_i)
      prev_q   = first_q == 1 ? 4       : first_q - 1
      prev_yr  = first_q == 1 ? first_yr - 1 : first_yr
      points = [{ kind: :confirmed, label: "Q#{prev_q} #{prev_yr}", count: 0, y_max: y_max }]

      points += sorted_keys.map do |key|
        yr, q = key.split("-Q")
        label = "Q#{q} #{yr}"
        if key == cur_key
          { kind: :current, label: label, count: raw_count,
            projected: projected_count, progress: progress, y_max: y_max }
        else
          { kind: :confirmed, label: label, count: counts[key], y_max: y_max }
        end
      end

      if completed_keys.any?
        points << { kind: :next, label: "Q#{next_q} #{next_yr}",
                    count: next_count, y_max: y_max }
      end

      points
    end

    # ------------------------------------------------------------------ geometry

    def x_for(index, total)
      return LEFT + WIDTH / 2 if total == 1
      LEFT + (index * WIDTH.to_f / (total - 1)).round
    end

    def y_for(count, y_max)
      BOTTOM - (count * HEIGHT.to_f / y_max).round
    end

    # ------------------------------------------------------------------ SVG helpers

    def tag(name, attrs = {}, content = nil)
      attr_str = attrs.map { |k, v| %( #{k}="#{v}") }.join
      if content
        "<#{name}#{attr_str}>#{content}</#{name}>"
      else
        "<#{name}#{attr_str}/>"
      end
    end

    def polyline(points, attrs = {})
      pts = points.map { |x, y| "#{x},#{y}" }.join(" ")
      tag(:polyline, { points: pts, fill: "none" }.merge(attrs))
    end

    def path(d, attrs = {})
      tag(:path, { d: d }.merge(attrs))
    end

    def area_path(pts_above, x_start, x_end)
      coords = pts_above.map { |x, y| "#{x},#{y}" }.join(" L ")
      "M #{x_start},#{BOTTOM} L #{coords} L #{x_end},#{BOTTOM} Z"
    end

    def text_el(x, y, content, attrs = {})
      defaults = { "font-family": FONT }
      tag(:text, { x: x, y: y }.merge(defaults).merge(attrs), content)
    end

    # ------------------------------------------------------------------ build

    def build_svg(cves)
      pts    = build_points(cves)
      n      = pts.size
      y_max  = pts.first&.dig(:y_max) || 5
      tick_step = y_max / 5

      # Compute pixel coords for every point
      coords = pts.each_with_index.map do |pt, i|
        [x_for(i, n), y_for(pt[:count], y_max)]
      end

      # Split into confirmed (including :current real dot) vs next-only
      confirmed_idx = pts.each_index.reject { |i| pts[i][:kind] == :next }
      next_idx      = pts.each_index.select { |i| pts[i][:kind] == :next }
      cur_idx       = pts.each_index.find   { |i| pts[i][:kind] == :current }

      solid_coords  = confirmed_idx.map { |i| coords[i] }
      solid_area    = area_path(solid_coords, solid_coords.first[0], solid_coords.last[0])

      # Dashed segments and filled regions
      dashed_segs   = []
      triangle_path = nil
      extrap_area   = nil

      if cur_idx
        cur_pt    = pts[cur_idx]
        cx, cy    = coords[cur_idx]
        proj_y    = y_for(cur_pt[:projected], y_max)

        # Triangle: prev-real → proj-Q2 → real-Q2 (closed)
        # The base (prev-real → real-Q2) is already drawn by the solid line.
        # We add the two dashed edges and fill the triangle.
        if cur_idx > 0
          prev_x, prev_y = coords[cur_idx - 1]
          # dashed hypotenuse: prev-real → proj-Q2
          dashed_segs << [[prev_x, prev_y], [cx, proj_y]]
          # triangle fill
          triangle_path = "M #{prev_x},#{prev_y} L #{cx},#{proj_y} L #{cx},#{cy} Z"
        end

        if next_idx.any?
          nx, ny = coords[next_idx.first]
          # projected dot → next quarter
          dashed_segs << [[cx, proj_y], [nx, ny]]
          extrap_area = area_path([[cx, proj_y], [nx, ny]], cx, nx)
        end
      end

      lines = []

      # ── defs ──────────────────────────────────────────────────────────
      lines << <<~SVG
        <defs>
          <linearGradient id="cveChartFill" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%"   stop-color="#{COLOR}" stop-opacity="0.20"/>
            <stop offset="100%" stop-color="#{COLOR}" stop-opacity="0.02"/>
          </linearGradient>
          <linearGradient id="cveChartFillX" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%"   stop-color="#{COLOR}" stop-opacity="0.09"/>
            <stop offset="100%" stop-color="#{COLOR}" stop-opacity="0.01"/>
          </linearGradient>
          <pattern id="cveHatch" patternUnits="userSpaceOnUse" width="6" height="6" patternTransform="rotate(45)">
            <line x1="0" y1="0" x2="0" y2="6" stroke="#{COLOR}" stroke-width="1" stroke-opacity="0.18"/>
          </pattern>
        </defs>
      SVG

      # ── grid ──────────────────────────────────────────────────────────
      (0..5).each do |n|
        val = n * tick_step
        ty  = y_for(val, y_max)
        lines << tag(:line, x1: LEFT, y1: ty, x2: RIGHT, y2: ty,
                     stroke: GRID_COLOR, "stroke-width": 1)
        lines << text_el(LEFT - 6, ty + 4, val.to_s,
                         "text-anchor": "end", "font-size": 11, fill: AXIS_COLOR)
      end

      # ── axes ──────────────────────────────────────────────────────────
      lines << tag(:line, x1: LEFT, y1: TOP, x2: LEFT, y2: BOTTOM,
                   stroke: "currentColor", "stroke-width": 1, opacity: 0.3)
      lines << tag(:line, x1: LEFT, y1: BOTTOM, x2: RIGHT, y2: BOTTOM,
                   stroke: "currentColor", "stroke-width": 1, opacity: 0.3)

      # ── fills ─────────────────────────────────────────────────────────
      lines << path(solid_area, fill: "url(#cveChartFill)")
      if triangle_path
        lines << path(triangle_path, fill: "url(#cveChartFillX)")
        lines << path(triangle_path, fill: "url(#cveHatch)")
      end
      if extrap_area
        lines << path(extrap_area, fill: "url(#cveChartFillX)")
        lines << path(extrap_area, fill: "url(#cveHatch)")
      end

      # ── solid line ────────────────────────────────────────────────────
      lines << polyline(solid_coords, stroke: COLOR, "stroke-width": 2.5,
                        "stroke-linejoin": "round", "stroke-linecap": "round")

      # ── dashed segments ───────────────────────────────────────────────
      dashed_segs.each do |seg|
        lines << polyline(seg, stroke: COLOR, "stroke-width": 2,
                          "stroke-dasharray": "5 4",
                          "stroke-linejoin": "round", "stroke-linecap": "round",
                          opacity: 0.6)
      end

      # ── dots and labels ───────────────────────────────────────────────
      pts.each_with_index do |pt, i|
        cx, cy = coords[i]
        lq, ly = pt[:label].split(" ")

        case pt[:kind]
        when :confirmed
          lines << tag(:circle, { cx: cx, cy: cy, r: 5, fill: COLOR,
                        stroke: "#fff", "stroke-width": 2, class: "chart-dot" },
                        tag(:title, {}, "#{pt[:label]}: #{pt[:count]} CVE#{pt[:count] == 1 ? '' : 's'}"))

        when :current
          proj_y = y_for(pt[:projected], y_max)
          # Real dot (solid)
          lines << tag(:circle, { cx: cx, cy: cy, r: 5, fill: COLOR,
                        stroke: "#fff", "stroke-width": 2, class: "chart-dot" },
                        tag(:title, {}, "#{pt[:label]}: #{pt[:count]} CVEs published (#{(pt[:progress] * 100).round}% of quarter elapsed)"))
          # Projected dot (hollow)
          lines << tag(:circle, { cx: cx, cy: proj_y, r: 5, fill: "#fff",
                        stroke: COLOR, "stroke-width": 2, "stroke-dasharray": "3 2",
                        opacity: 0.75, class: "chart-dot" },
                        tag(:title, {}, "#{pt[:label]} projected: ~#{pt[:projected]} CVEs"))

        when :next
          lines << tag(:circle, { cx: cx, cy: cy, r: 5, fill: "#fff",
                        stroke: COLOR, "stroke-width": 2, "stroke-dasharray": "3 2",
                        opacity: 0.75, class: "chart-dot" },
                        tag(:title, {}, "#{pt[:label]} forecast: ~#{pt[:count]} CVEs (linear trend)"))
        end

        extrap = pt[:kind] == :next
        label_fill    = extrap ? "#adb5bd" : AXIS_COLOR
        label_opacity = extrap ? 0.7 : 1

        lines << text_el(cx, BOTTOM + 20, lq, "text-anchor": "middle",
                         "font-size": 12, fill: label_fill, opacity: label_opacity)
        lines << text_el(cx, BOTTOM + 34, ly, "text-anchor": "middle",
                         "font-size": 11, fill: "#adb5bd", opacity: label_opacity)
      end


      # ── legend ────────────────────────────────────────────────────────
      legend_y = BOTTOM + 52
      legend_items = [
        { dash: false, label: "Actual CVEs" },
        { dash: true,  label: "Projected / Forecast" },
      ]
      legend_total_width = legend_items.sum { |item| item[:label].length * 6.5 + 40 }
      legend_x = (VIEW_W - legend_total_width) / 2
      cursor_x = legend_x
      legend_items.each do |item|
        line_attrs = {
          x1: cursor_x, y1: legend_y, x2: cursor_x + 24, y2: legend_y,
          stroke: COLOR, "stroke-width": 2, "stroke-linecap": "round"
        }
        line_attrs[:"stroke-dasharray"] = "5 4" if item[:dash]
        line_attrs[:opacity] = 0.6 if item[:dash]
        lines << tag(:line, line_attrs)
        dot_attrs = { cx: cursor_x + 12, cy: legend_y, r: 4,
                      fill: item[:dash] ? "#fff" : COLOR,
                      stroke: COLOR, "stroke-width": 2 }
        dot_attrs[:"stroke-dasharray"] = "3 2" if item[:dash]
        lines << tag(:circle, dot_attrs)
        lines << text_el(cursor_x + 30, legend_y + 4, item[:label],
                         "font-size": 11, fill: AXIS_COLOR)
        cursor_x += item[:label].length * 6.5 + 40
      end

      svg_attrs = [
        'viewBox="0 0 700 280"',
        'xmlns="http://www.w3.org/2000/svg"',
        'role="img"',
        'aria-label="CVE publications by quarter"',
        'style="width:100%;height:auto;display:block;"',
      ].join(" ")

      inner = lines.join("\n  ")
      "<svg #{svg_attrs}>\n  <title>CVE Publications by Quarter</title>\n  #{inner}\n</svg>\n"
    end
  end
end
