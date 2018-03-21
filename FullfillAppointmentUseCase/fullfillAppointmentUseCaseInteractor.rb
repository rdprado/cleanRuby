require './Entities/appointment'

class FullfillAppointmentUseCaseModels
    ReqModel = Struct.new(:clientId, :coachId, :date)
    ResModel = Struct.new(:clientId, :coachId, :date) 
end

#class FullfillAppointmentDataErrors
class CannnotFetchAppointment < StandardError
end
#end

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