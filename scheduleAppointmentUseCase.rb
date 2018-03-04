require './appointment'

class ScheduleAppointmentUseCase

    def initialize(appointmentRepository, scheduleAppointmentUseCaseOutputPort)
        @appointmentRepository = appointmentRepository
        @scheduleAppointmentUseCaseOutputPort = scheduleAppointmentUseCaseOutputPort
    end

    def scheduleAppointment(reqModel)
        isRequestValid = @appointmentRepository.isClientAClientOfThisProfessor()
        if isRequestValid
            appointment = Appointment.new(reqModel.professorId, reqModel.clientId, reqModel.date)
            @appointmentRepository.scheduleAppointment(appointment) { 
                |appointmentId| @scheduleAppointmentUseCaseOutputPort.presentAppointment(appointmentId)
            }
        else
            @scheduleAppointmentUseCaseOutputPort.presentError("CannotScheduleAppointmentError", "Client #{reqModel.clientId} not a client of professor #{reqModel.professorId}");
        end
    end
end