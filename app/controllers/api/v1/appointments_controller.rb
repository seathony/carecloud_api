class Api::V1::AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]


  def index
    # @appointments = Appointment.all
    # @appointments = Appointment.where(nil) # creates an anonymous scope
    @appointments = Appointment.order("id asc")
    @appointments = @appointments.start_time(params[:start_time]) if params[:start_time].present?
    @appointments = @appointments.end_time(params[:end_time]) if params[:end_time].present?


    render json: @appointments, status: :ok
  end

  def show
      render json: @appointment
  end

  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: @appointment, status: :created
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @appointment.update(appointment_params)
      head :no_content
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @appointment.destroy

    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def appointment_params
      params.require(:appointment).permit(:start_time, :end_time, :first_name, :last_name, :comments)
    end
end
