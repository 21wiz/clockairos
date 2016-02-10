class SessionsController < ApplicationController

  # GET /sessions
  # GET /sessions.json
  def index
    flash[:alert] = "Thank You! for showing interest on ClocKairos. This Application will go live soon"
  end

  # GET /sessions
  #def login
    #flash[:alert] = "Thank You! for showing interest on ClocKairos. This Application will go live soon"
    #format.html { redirect_to session_path, notice:  "Have the greatest of days!"}

   # respond_to do |format|
   #   format.html { redirect_to sessions_path, notice:  "Have the greatest of days!"}
   # end
  #end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions
  # POST /sessions.json
  def create
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
  end

end
