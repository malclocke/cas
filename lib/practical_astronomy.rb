require 'forwardable'

class PracticalAstronomy
  def self.all(resources)
    resources.select do |resource|
      is_practical_astronomy?(resource)
    end.map do |resource|
      new(resource)
    end
  end

  def self.is_practical_astronomy?(resource)
    resource.destination_path =~ /\Asociety\/practical-astronomy\/\d\d\d\d-\d\d-\d\d/
  end

  attr_reader :resource

  extend Forwardable
  def_delegators :data, :title, :date
  def_delegators :resource, :data, :url
  def_delegators :date, :year

  def initialize(resource)
    @resource = resource
  end

end
