require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable
  before_action :set_ifcall

  after_filter :set_header

  skip_before_action :verify_authenticity_token

# POST /twilio/process_sms/
  def process_sms
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
    which_state = params[:FromState]
    id_state= params[:Body]
    if which_state==id_state
        render 'process_sms.xml.erb', :content_type => 'text/xml'
        ifcall = "0"
    else
        render 'process_sms2.xml.erb', :content_type => 'text/xml'
        ifcall = "1"
    end
  end

# POST /twilio/voice
  def voice
      if ifcall=="1"
        response = Twilio::TwiML::Response.new do |r|
          r.Say 'Hey there. Congrats on finding out that you an also call Clock Kairos', :voice => 'alice'
          r.Play 'http://linode.rabasa.com/cantina.mp3'
        render_twiml response
        break
      else
        break
      end
  end

# POST /twilio/call
  def call
    @city = params[:FromCity]
    citystr = params[:FromCity]
    @state = params[:FromState]
    statestr = params[:FromState]
    if ifcall=="1"
      response = Twilio::TwiML::Response.new do |r|
        r.Say "Hey there . Congrats waking up on time! It is a beautiful day in #{citystr}, #{statestr}. Now gather your energy and GO CHANGE THE WORLD!", :voice => 'man'
        r.Play 'http://linode.rabasa.com/cantina.mp3'
      render_twiml response
    else
      ifcall="1"
      break
    end
  end

  private 
    def set_ifcall
      ifcall=1
    end
  end
end
