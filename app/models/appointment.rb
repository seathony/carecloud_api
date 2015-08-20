class Appointment < ActiveRecord::Base


  scope :start_time, -> (start_time) { where start_time: start_time }
  scope :end_time, -> (end_time) { where end_time: end_time }


  before_validation on: [:create, :update]

  validates_presence_of :start_time, :end_time, :first_name, :last_name

  validate :start_before_end
  validate :start_future_time
  validate :end_future_time
  validate :start_overlap
  validate :end_overlap


  private

  def start_before_end
    errors.add(:start_time, "Enter date before end_time. start_time: '#{start_time}', end_time: '#{end_time}'") if (start_time > end_time)
  end

  def start_future_time
     if (start_time_changed? == true)
      errors.add(:start_time, "The date has to be now, like in the present. start_time: '#{start_time}'") if (start_time < Time.zone.now)
    end
  end

  def end_future_time
    if (end_time_changed? == true)
      errors.add(:end_time, "The date has to be now, like in the present. end_time: '#{end_time}'") if (end_time < Time.zone.now)
    end
  end

  def start_overlap
    if (Appointment.exists?(["(start_time <= ?) AND (? <= end_time) AND id != ?", start_time, start_time, id || 0]))
      overlap = Appointment.select('id').where(["(start_time <= ?) AND (? <= end_time) AND id != ?", start_time, start_time, id || 0])
      errors.add(:start_time, "Sorry that date exists. Overlaps with record id's: " + overlap.collect{ |i| i['id'] }.inspect)
    end
  end

  def end_overlap
    if (Appointment.exists?(["(start_time <= ?) AND (? <= end_time) AND id != ?", end_time, end_time, id || 0]))
      overlap = Appointment.select('id').where(["(start_time <= ?) AND (? <= end_time) AND id != ?", end_time, end_time, id || 0])
      errors.add(:end_time, "Sorry that date exists. Overlaps with record id's: " + overlap.collect{ |i| i['id'] }.inspect)
    end
  end
end
