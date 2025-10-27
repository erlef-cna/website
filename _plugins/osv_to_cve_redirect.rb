require 'jekyll-datapage-generator'
require 'jekyll-redirect-from'

module OSVToCVERedirects
  def initialize(site, base, index_files, dir, page_data_prefix, data, name, name_expr, title, title_expr, template, extension, debug)
    result = super(site, base, index_files, dir, page_data_prefix, data, name, name_expr, title, title_expr, template, extension, debug)

    if extension == 'html' && template == 'cve'
      self.data['redirect_from'] = ["/osv/EEF-#{@name}"]  # Example modification to the page data
    end

    result
  end
end

Jekyll::DataPage.prepend(OSVToCVERedirects)
