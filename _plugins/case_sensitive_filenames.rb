# Monkey patch for jekyll-datapage_gen to preserve case in filenames
# Overrides the sanitize_filename method to remove the .downcase conversion

puts "=== LOADING CASE SENSITIVE FILENAMES PLUGIN ==="

# Ensure the original plugin is loaded first
require 'jekyll-datapage-generator'

puts "=== JEKYLL-DATAPAGE-GENERATOR LOADED ==="

# Create a module to override the sanitize_filename method
module CaseSensitiveFilenames
  def sanitize_filename(name)
    return name.to_s if(name.is_a? Integer)

    result = name.tr(
      "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÑñÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž\\",
      "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuWwYyyYyYZzZzZz"
    ).strip.gsub(' ', '-').gsub(/[^\w.-]/, '')

    result
  end
end

puts "=== PREPENDING CASE SENSITIVE FILENAMES MODULE ==="
# Use prepend to override the original method
Jekyll::Sanitizer.prepend(CaseSensitiveFilenames)
puts "=== PREPEND COMPLETED ==="