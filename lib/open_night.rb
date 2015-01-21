require 'forwardable'
#
# Open night metadata is as follows:
#
# ---
# date: 2014-03-29
# group_booking: Earth Hour 8:00pm to 9:30pm
# moon_phase: 20
# moon_viewable: true
# go_ahead: true
# show_nights_in_advance: 6
# status_message: Obs is open tonight
# helpers:
#   - Gary Steel
#   - Malcolm Locke
# ---
#
class OpenNight

  UPCOMING_DAYS = 14

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

  def to_json(*a)
    to_h.merge('date' => date).to_json(*a)
  end

  def to_h
    data
  end

  def partial_name
    :open_night
  end

  def data
    resource.data
  end

  def url
    resource.url
  end

  def date
    @date ||= data.date
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
    future? && date - Date.today < UPCOMING_DAYS
  end

  def go_ahead?
    data.go_ahead
  end

end
