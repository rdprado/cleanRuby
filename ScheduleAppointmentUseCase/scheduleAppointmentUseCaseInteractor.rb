require './Entities/appointment'

class ScheduleAppointmentUseCaseInteractor

    ReqModel = Struct.new(:clientId, :coachId, :date, :title)
    ResModel = Struct.new(:clientId, :clientName, :coachId, :coachName, :date, :title)

    NotAClientOfProfessorResModel = Struct.new(:clientId, :clientName, :coachId, :coachName)
    UnexistentClientResModel = Struct.new(:clientId)
    UnexistentCoachResModel = Struct.new(:coachId)

    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def scheduleAppointment(reqModel)
        @repository.doesClientExist(reqModel.clientId) {
            |doesClientExist, client| 
            doesClientExist ? clientExistsCheckCoach(client, reqModel) : clientDoesntExistError(reqModel.clientId)
        } 
    end

    def clientExistsCheckCoach(client, reqModel)
        @repository.doesCoachExist(reqModel.coachId) {
            |doesCoachExist, coach| 
            doesCoachExist ? clientAndCoachExist(client, coach, reqModel) : coachDoesntExistError(coachId)
        }
    end

    def clientAndCoachExist(client, coach, reqModel)
        @repository.isClientAClientOfThisCoach(client, coach){
            |isClient| isClient ? validClientAndCoach(client, coach, reqModel) : notAClient(client, coach)
        }
    end

    def validClientAndCoach(client, coach, reqModel)
        appointment = Appointment.new(reqModel.date, reqModel.title)
        @repository.scheduleAppointment(appointment) {
            resModel = ResModel.new(client.id, client.name, coach.id, coach.name, appointment.date, appointment.title);
            @interactorOutput.presentAppointment(resModel)
        } 
    end

    def clientDoesntExistError(clientId)
        resModel = UnexistentClientResModel.new(clientId)
         @interactorOutput.presentUnexistentClientError(resModel)
    end

    def coachDoesntExistError(coachId)
        resModel = UnexistentCoachResModel.new(coachId)
        @interactorOutput.presentUnexistentCoachError(resModel)
    end

    def notAClient(client, coach)
        resModel = NotAClientOfProfessorResModel.new(client.id, client.name, coach.id, coach.name)
        @interactorOutput.presentNotAClientOfProfessorError(resModel)
    end


end