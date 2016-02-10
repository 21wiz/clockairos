require 'rubygems' # not necessary with ruby 1.9 but included for completeness 
require 'twilio-ruby' 
class Appointment < ActiveRecord::Base
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :time, presence: true

  after_create :reminder
  after_create :reminderCall

  @@REMINDER_TIME = 5.minutes # minutes before appointment
  @@REMINDERGONNACALL_TIME = 1.minutes # minutes before appointment
  @@REMINDERCALL_TIME = 0.minutes # minutes before appointment

  # Notify our appointment attendee X minutes before the appointment time
  def reminder
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    time_str = (self.time).strftime("%I:%M%p") #on %b. %d, %Y
    reminder = "Hi #{self.name}. You shold be waking up soon. If you don't answer this message in the next 7 minnutes with today's date as 'mmddyyy' I'll really make sure you wake up, trust me. Alarm setted to #{(self.time).localtime}"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :body => reminder,
    )
    puts message.to
  end

  def reminderGonnaCall
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    time_str = (self.time).strftime("%I:%M%p ") #on %b. %d, %Y
    reminderCall = "Hi #{self.name}. It's time, actually it's #{time_str} in Ireland, so I'm Calling..."
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :body => reminderCall,
    )
    puts message.to
  end

  # Set Up the call
  def reminderCall
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :url => 'https://clockairos.herokuapp.com/twilio/twilio/process_sms',
      :method => 'POST',
      :fallback_method => 'GET',
      :status_callback_method => 'GET',
      :if_machine => 'Hangup',
      :timeout => '30',
      :record => 'false'
    )
    puts message.to
  end

  # Here we define the times of each event
  def when_to_run
    time - @@REMINDER_TIME
  end
  def when_to_gonna_call
    time - @@REMINDERGONNACALL_TIME
  end
  def when_to_call
    time - @@REMINDERCALL_TIME
  end

  # We set the tasks to run asynchronously for each event
  handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
  handle_asynchronously :reminderGonnaCall, :run_at => Proc.new { |i| i.when_to_gonna_call }
  handle_asynchronously :reminderCall, :run_at => Proc.new { |i| i.when_to_call }
end
