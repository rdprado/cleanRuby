require './Entities/appointment'
require './UseCases/FullfillAppointment/fullfillAppointmentDataErrors'
require './UseCases/FullfillAppointment/fullfillAppointmentUseCaseModels'
require './logger'

class FullfillAppointmentUseCaseInteractor
    # def initialize(repository, interactorOutput, logger)
    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def fullfillAppointment(reqModel)
        begin
            @repository.fetchAppointment(reqModel.clientEmail, reqModel.coachEmail, reqModel.date) {
                |clientEmail, coachEmail, appointment|
                appointment.fullfill()
                @repository.saveAppointment(appointment) {
                    resModel = FullfillAppointmentUseCaseModels::ResModel.new(clientEmail, coachEmail, appointment.date)
                    @interactorOutput.presentFullfilledAppointment(resModel)
                }
            }
        rescue CannnotFetchAppointment => e
            @interactorOutput.presentCannotFetchAppointment(e.message)
        rescue StandardError => e
            Logger.error("Cannot fullfill appointment for\n
            client: #{reqModel.clientEmail}\n
            coach: #{reqModel.coachEmail}\n
            data: #{reqModel.date}")
        end
    end
end