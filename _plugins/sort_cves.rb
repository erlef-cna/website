module Jekyll
  module SortCvesFilter
    def sort_cves_by_date(cves)
      cves.sort_by { |_key, value| value.dig("cveMetadata", "datePublished") || "" }.reverse
    end
  end
end

Liquid::Template.register_filter(Jekyll::SortCvesFilter)
