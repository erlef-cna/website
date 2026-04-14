module Jekyll
  module LinkCommitShasFilter
    # Links <tt>SHA</tt> tags to their GitHub commit URLs if found in references.
    #
    # Usage: {{ html_content | link_commit_shas: references }}
    #
    # Where references is an array of objects with "url" keys containing
    # GitHub commit URLs like https://github.com/org/repo/commit/SHA
    def link_commit_shas(content, references)
      return content if content.nil? || references.nil?

      # Build a hash of full SHA -> GitHub commit URL
      sha_to_url = {}
      references.each do |ref|
        url = ref["url"]
        next unless url

        # Match GitHub commit URLs
        if url =~ %r{https://github\.com/[^/]+/[^/]+/commit/([a-f0-9]{40})}i
          sha_to_url[$1.downcase] = url
        end
      end

      return content if sha_to_url.empty?

      commit_icon = '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: text-bottom; margin-right: 2px;"><circle cx="12" cy="12" r="3"/><line x1="3" y1="12" x2="9" y2="12"/><line x1="15" y1="12" x2="21" y2="12"/></svg>'

      # First pass: replace <tt>SHA</tt> with linked version
      result = content.gsub(%r{<tt>([a-f0-9]{40})</tt>}i) do |match|
        sha = $1.downcase
        if sha_to_url.key?(sha)
          url = sha_to_url[sha]
          short_sha = sha[0, 10]
          %(<a href="#{url}" target="_blank">#{commit_icon}<tt>#{short_sha}</tt></a>)
        else
          match
        end
      end

      # Second pass: replace bare SHAs (not already inside tags)
      # Use negative lookbehind/lookahead to avoid matching SHAs already in URLs or tags
      result.gsub(%r{(?<![/"=>])([a-f0-9]{40})(?![a-f0-9]|</tt>|</a>|")}i) do |match|
        sha = $1.downcase
        if sha_to_url.key?(sha)
          url = sha_to_url[sha]
          short_sha = sha[0, 10]
          %(<a href="#{url}" target="_blank">#{commit_icon}<tt>#{short_sha}</tt></a>)
        else
          match
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkCommitShasFilter)
