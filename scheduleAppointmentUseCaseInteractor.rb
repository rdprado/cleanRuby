require './appointment'

class ScheduleAppointmentUseCaseInteractor

    ReqModel = Struct.new(:coachId, :clientId, :date)
    ResModel = Struct.new(:coachId, :coachName, :clientId, :clientName, :date)

    NotAClientResModel = Struct.new(:coachId, :clientId)

    def initialize(appointmentRepository, interactorOutput)
        @appointmentRepository = appointmentRepository
        @interactorOutput = interactorOutput
    end

    def scheduleAppointment(reqModel)
        if @appointmentRepository.isClientAClientOfThisCoach()
            appointment = Appointment.new(reqModel.coachId, reqModel.clientId, reqModel.date)
            @appointmentRepository.scheduleAppointment(appointment) { 
                |clientId, clientName, coachId, coachName, date|
                resModel = ResModel.new(clientId, clientName, coachId, coachName, date);
                @interactorOutput.presentAppointment(resModel)
            }
        else
            resModel = NotAClientResModel.new(reqModel.clientId, reqModel.coachId);
            @interactorOutput.presentNotAClientOfProfessorError(resModel);
        end
    end
end