require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

# POST /twilio/process_sms/1
  def process_sms
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
    if params[:Body]==params[:from]
        render 'process_sms.xml.erb', :content_type => 'text/xml'
        Appointment.first(:conditions => "phone_number = params[:from]").destroy
      else
        render 'process_sms2.xml.erb', :content_type => 'text/xml'
      end
  end

# POST /twilio/voice
  def voice
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hey there. Congrats on finding out that you an also call Clock Kairos', :voice => 'alice'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

# POST /twilio/call
  def call
    @city = params[:FromCity]
    citystr = params[:FromCity]
    @state = params[:FromState]
    statestr = params[:FromState]
    #namestr = appointment_params[:name]
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say "Hey there . Congrats waking up on time! It is a beautiful day in #{citystr}, #{statestr}. Now gather your energy and GO CHANGE THE WORLD!", :voice => 'man'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

end
