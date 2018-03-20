class AddClientToCoachUseCase

    ReqModel = Struct.new(:clientEmail, :coachEmail)
    ResModel = Struct.new(:clientEmail, :clientName, :coachEmail, :coachName)

    AlreadyAClientResModel = Struct.new(:clientEmail, :clientName, :coachEmail, :coachName)
    UnexistentClientResModel = Struct.new(:clientEmail)
    UnexistentCoachResModel = Struct.new(:coachEmail)

    def initialize(coachRepository, interactorOutput)
        @coachRepository = coachRepository
        @interactorOutput = interactorOutput
    end

    def addClientToCoach(reqModel)
        @coachRepository.doesClientExist(reqModel.clientEmail) {
            |doesClientExist, client| 
            doesClientExist ? clientExistsCheckCoach(client, reqModel.coachEmail) : clientDoesntExistError(reqModel.clientEmail)
        } 
    end

    def clientExistsCheckCoach(client, coachEmail)
        @coachRepository.doesCoachExist(coachEmail) {
            |doesCoachExist, coach| 
            doesCoachExist ? clientAndCoachExist(client, coach) : coachDoesntExistError(coachEmail)
        }
    end

    def clientAndCoachExist(client, coach)
        @coachRepository.isClientAClientOfThisCoach(client, coach){
            |isAlreadyAClient| !isAlreadyAClient ? valemailClientAndCoach(client, coach) : alreadyAClientError(client, coach)
        }
    end

    def valemailClientAndCoach(client, coach)
        @coachRepository.addClientToCoach(client, coach) {
            resModel = ResModel.new(client.email, client.name, coach.email, coach.name)
            @interactorOutput.presentAddedClientToCoach(resModel)
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

    def alreadyAClientError(client, coach)
        resModel = AlreadyAClientResModel.new(client.email, client.name, coach.email, coach.name)
        @interactorOutput.presentAlreadyAClientError(resModel)
    end
    
end
