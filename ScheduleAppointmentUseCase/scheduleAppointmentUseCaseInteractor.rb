require './Entities/appointment'

class ScheduleAppointmentUseCaseInteractor

    ReqModel = Struct.new(:clientEmail, :coachEmail, :date, :title)
    ResModel = Struct.new(:clientEmail, :clientName, :coachEmail, :coachName, :date, :title)

    NotAClientOfProfessorResModel = Struct.new(:clientEmail, :clientName, :coachEmail, :coachName)
    UnexistentClientResModel = Struct.new(:clientEmail)
    UnexistentCoachResModel = Struct.new(:coachEmail)

    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def scheduleAppointment(reqModel)
        @repository.doesClientExist(reqModel.clientEmail) {
            |doesClientExist, client| 
            doesClientExist ? clientExistsCheckCoach(client, reqModel) : clientDoesntExistError(reqModel.clientEmail)
        } 
    end

    def clientExistsCheckCoach(client, reqModel)
        @repository.doesCoachExist(reqModel.coachEmail) {
            |doesCoachExist, coach| 
            doesCoachExist ? clientAndCoachExist(client, coach, reqModel) : coachDoesntExistError(reqModel.coachEmail)
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
            resModel = ResModel.new(client.email, client.name, coach.email, coach.name, appointment.date, appointment.title);
            @interactorOutput.presentAppointment(resModel)
        } 
    end

    def clientDoesntExistError(clientEmail)
        resModel = UnexistentClientResModel.new(clientEmail)
         @interactorOutput.presentUnexistentClientError(resModel)
    end

    def coachDoesntExistError(coachEmail)
        resModel = UnexistentCoachResModel.new(coachEmail)
        @interactorOutput.presentUnexistentCoachError(resModel)
    end

    def notAClient(client, coach)
        resModel = NotAClientOfProfessorResModel.new(client.email, client.name, coach.email, coach.name)
        @interactorOutput.presentNotAClientOfProfessorError(resModel)
    end


end