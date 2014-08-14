require 'rspec'
#require 'valvat'
require 'eurovat'
require 'rails/all'
#require 'active_model/validations/valvat_validator'

begin
  require 'active_model'
rescue LoadError => err
  puts "Running specs without active_model extension"
end

#if defined?(ActiveModel)
  #class ModelBase
    #include ActiveModel::Serialization
    #include ActiveModel::Validations

    #attr_accessor :attributes

    #def initialize(attributes = {})
      #@attributes = attributes
    #end

    #def read_attribute_for_validation(key)
      #@attributes[key]
    #end
  #end
#end
