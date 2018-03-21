require './Entities/appointment'
class FullfillAppointmentUseCaseInteractor

    ReqModel = Struct.new(:clientId, :coachId, :date)
    ResModel = Struct.new(:clientId, :coachId, :date)

    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def fullfillAppointment(reqModel)
        @repository.fetchAppointment(reqModel.clientId, reqModel.coachId, reqModel.date) {
            |clientId, coachId, appointment|
            appointment.fullfill()
            @repository.saveAppointment(appointment) {
                resModel = ResModel.new(clientId, coachId, appointment.date)
                @interactorOutput.presentFullfilledAppointment(resModel)
            }
        }
    end

end