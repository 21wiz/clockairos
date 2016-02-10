require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

# POST /twilio/process_sms
  def process_sms
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
    render 'process_sms.xml.erb', :content_type => 'text/xml'
  end

# POST /twilio/voice
  def voice
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

# POST /twilio/call
  def call
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hey there. Congrats waking up on time! It is a beautiful day in #{city}, #{state}. Now gather that energy and GO CHANGE THE WORLD!', :voice => 'alice'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

end
