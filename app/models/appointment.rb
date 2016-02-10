require 'rubygems' # not necessary with ruby 1.9 but included for completeness 
require 'twilio-ruby' 
class Appointment < ActiveRecord::Base
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :time, presence: true

  after_create :reminder
  after_create :reminderGonnaCall
  after_create :reminderCall
  @@REMINDER_TIME = 7.minutes # minutes before appointment
  @@REMINDERGONNACALL_TIME = 3.minutes # minutes before appointment
  @@REMINDERCALL_TIME = 1.minutes # minutes before appointment

  # Notify our appointment attendee X minutes before the appointment time
  def reminder
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    time_str = (self.time).strftime("%I:%M%p") #on %b. %d, %Y
    app_id = self.id
    reminder = "Hi #{self.name}. You shold be waking up soon. If you don't want to be disturbed answer this message in the next 7 minutes only with the two letters of your state, like 'IL'. Otherwise I'll really make sure you wake up, trust me."
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
    reminderGonnaCall = "Hi #{self.name}. It's time, actually it's #{time_str} in Ireland (sound pretty late to wake up huh), so I'm Calling..."
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :body => reminderGonnaCall,
    )
    puts message.to
  end

  # Set Up the call
  def reminderCall
    @twilio_number = ENV['TWILIO_NUMBER']
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    call = @client.account.calls.create(
      :from => @twilio_number,
      :to => self.phone_number,
      :url => 'https://clockairos.herokuapp.com/twilio/call',
      :method => 'POST',
      :fallback_method => 'GET',
      :status_callback_method => 'GET',
      :if_machine => 'Hangup',
      :timeout => '30',
      :record => 'false'
    )
    puts call.to
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
