class TechModApplier
  class << self
    # Returns Hash of
    # {
    #   full_camelcased_class_name(String) =>
    #     summed_percentage_as_float(Float)
    # } pairs for mod _name_.
    #
    # Hash is created from _technologies_ by checking which technologies
    # have this mod.
    # 
    def apply(technologies, name)
      store = {}

      value_method = "#{name}_mod"
      check_method = "#{name}_mod?"

      technologies.each do |technology|
        if technology.send(check_method)
          value = technology.send(value_method).to_f / 100
          technology.applies_to.each do |class_name|
            store[class_name] ||= 0
            store[class_name] += value
          end
        end
      end

      store
    end
  end
end
