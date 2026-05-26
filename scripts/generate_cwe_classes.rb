#!/usr/bin/env ruby
# Downloads the CWE catalog and writes _data/cwe_classes.json:
# a map of CWE-ID => { "id" => "CWE-NNN", "name" => "..." } at Class level.
#
# Usage: ruby scripts/generate_cwe_classes.rb

require "open-uri"
require "tmpdir"
require "zip"
require "rexml/document"
require "json"

CATALOG_URL = "https://cwe.mitre.org/data/xml/cwec_latest.xml.zip"
OUT_PATH    = File.join(__dir__, "..", "_data", "cwe_classes.json")

# ── Download & extract ────────────────────────────────────────────────────────
puts "Downloading #{CATALOG_URL} ..."
zip_data = URI.open(CATALOG_URL, &:read)

xml_content = nil
Dir.mktmpdir do |dir|
  zip_path = File.join(dir, "cwec.zip")
  File.binwrite(zip_path, zip_data)
  Zip::File.open(zip_path) do |zip|
    entry = zip.find { |e| e.name.end_with?(".xml") }
    raise "No XML found in zip" unless entry
    puts "Extracting #{entry.name} ..."
    xml_content = entry.get_input_stream.read
  end
end

# ── Parse ─────────────────────────────────────────────────────────────────────
puts "Parsing XML ..."
doc  = REXML::Document.new(xml_content)
root = doc.root

# Build a lookup: id (string) => { abstraction:, name:, parents: [id, ...] }
nodes = {}
root.elements["Weaknesses"].elements.each("Weakness") do |w|
  id          = w.attributes["ID"]
  abstraction = w.attributes["Abstraction"]
  name        = w.attributes["Name"]
  parents     = []
  rw = w.elements["Related_Weaknesses"]
  rw&.elements&.each("Related_Weakness") do |r|
    parents << r.attributes["CWE_ID"] if r.attributes["Nature"] == "ChildOf"
  end
  nodes[id] = { abstraction: abstraction, name: name, parents: parents }
end

# Walk up the ChildOf chain until we reach a Class (or Pillar as fallback).
def find_class(id, nodes, cache = {})
  return cache[id] if cache.key?(id)
  node = nodes[id]
  return nil unless node

  if node[:abstraction] == "Class" || node[:abstraction] == "Pillar"
    return cache[id] = { "id" => "CWE-#{id}", "name" => node[:name] }
  end

  node[:parents].each do |parent_id|
    result = find_class(parent_id, nodes, cache)
    return cache[id] = result if result
  end

  # No class ancestor found — use self
  cache[id] = { "id" => "CWE-#{id}", "name" => node[:name] }
end

cache  = {}
result = {}
nodes.each_key do |id|
  cls = find_class(id, nodes, cache)
  result["CWE-#{id}"] = cls if cls
end

# ── Write ─────────────────────────────────────────────────────────────────────
File.write(OUT_PATH, JSON.pretty_generate(result.sort.to_h))
puts "Written #{result.size} entries to #{OUT_PATH}"
