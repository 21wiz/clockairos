require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  after_filter :set_header

  skip_before_action :verify_authenticity_token

# POST /twilio/process_sms/1
  def process_sms
    @city = params[:FromCity].capitalize
    @state = params[:FromState]
    yourPhone = "+1"+params[Body]
    if yourPhone.include? params[:from]
        render 'process_sms.xml.erb', :content_type => 'text/xml'
        @appointment.destroy
      else
        render 'process_sms2.xml.erb', :content_type => 'text/xml'
      end
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
    @city = params[:FromCity]
    citystr = params[:FromCity]
    @state = params[:FromState]
    statestr = params[:FromState]
    namestr = appointment_params[:name]
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hey there #{namestr}. Congrats waking up on time! It is a beautiful day in #{citystr}, #{statestr}. Now gather your energy and GO CHANGE THE WORLD!', :voice => 'alice'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # See above ---> before_action :set_appointment, only: [:show, :edit, :update, :destroy]
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:name, :phone_number, :time, :time_zone)
    end

end
