require './Entities/appointment'
require './FullfillAppointmentUseCase/fullfillAppointmentDataErrors'
require './FullfillAppointmentUseCase/fullfillAppointmentUseCaseModels'

class FullfillAppointmentUseCaseInteractor
    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def fullfillAppointment(reqModel)
        begin
            @repository.fetchAppointment(reqModel.clientId, reqModel.coachId, reqModel.date) {
                |clientId, coachId, appointment|
                appointment.fullfill()
                @repository.saveAppointment(appointment) {
                    resModel = FullfillAppointmentUseCaseModels::ResModel.new(clientId, coachId, appointment.date)
                    @interactorOutput.presentFullfilledAppointment(resModel)
                }
            }
        rescue CannnotFetchAppointment => e
            @interactorOutput.presentCannotFetchAppointment(e.message)
        end
    end
end