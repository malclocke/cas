require 'forwardable'

class OpenNight

  def self.all(resources)
    resources.select do |resource|
      resource.destination_path =~ /\Aopen-nights\/\d\d\d\d\/\d\d\d\d/
    end.map do |resource|
      new(resource)
    end.sort_by(&:date)
  end

  def self.future(resources)
    all(resources).select(&:future?)
  end

  def self.upcoming(resources)
    future(resources).select(&:upcoming?)
  end

  attr_reader :resource

  extend Forwardable
  def_delegators :data, :is_open, :group_booking, :moon_phase, :moon_viewable,
    :helpers

  def initialize(resource)
    @resource = resource
  end

  def data
    resource.data
  end

  def url
    resource.url
  end

  def date
    @date ||= Date.parse(data.date)
  end

  def time_start
    data.time_start || '7:30 pm'
  end

  def time_end
    data.time_start || '9:00 pm'
  end

  def status_message
    data.status_message || 'Please check later for a status update'
  end

  def more_helpers_needed?
    helpers.respond_to?(:count) && helpers.count < 3
  end
  
  def future?
    date >= Date.today
  end

  def upcoming?
    future? && date - Date.today < 7
  end

  def go_ahead?
    data.go_ahead
  end

end
