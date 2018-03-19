require './Entities/appointment'

class ScheduleAppointmentUseCaseInteractor

    ReqModel = Struct.new(:clientId, :coachId, :date)
    ResModel = Struct.new(:clientId, :clientName, :coachId, :coachName, :date)

    NotAClientResModel = Struct.new(:coachId, :clientId)

    def initialize(appointmentRepository, interactorOutput)
        @appointmentRepository = appointmentRepository
        @interactorOutput = interactorOutput
    end

    def scheduleAppointment(reqModel)
        @appointmentRepository.isClientAClientOfThisCoach() {
            |isClient| isClient ? clientIsAClientOfThisCoach(reqModel) : clientNotAClientOfThisCoach(reqModel)
        }
    end

    def clientIsAClientOfThisCoach(reqModel)
        appointment = Appointment.new(reqModel.coachId, reqModel.clientId, reqModel.date)
            @appointmentRepository.scheduleAppointment(appointment) { 
                |clientId, clientName, coachId, coachName, date|
                resModel = ResModel.new(clientId, clientName, coachId, coachName, date);
                @interactorOutput.presentAppointment(resModel)
            }
    end

    def clientNotAClientOfThisCoach(reqModel)
        resModel = NotAClientResModel.new(reqModel.clientId, reqModel.coachId);
                @interactorOutput.presentNotAClientOfProfessorError(resModel);
    end
end