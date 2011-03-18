# Suppresses ActiveRecords as_json. Include as first module when using
# multiple modules that extend #as_json.
module Parts::CleanAsJson
  def as_json(options=nil); {}; end
end