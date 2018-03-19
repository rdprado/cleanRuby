class AddClientToCoachUseCase

    ReqModel = Struct.new(:clientId, :coachId)
    ResModel = Struct.new(:clientId, :clientName, :coachId, :coachName)

    AlreadyAClientResModel = Struct.new(:clientId, :clientName, :coachId, :coachName)
    UnexistentClientResModel = Struct.new(:clientId)
    UnexistentCoachResModel = Struct.new(:coachId)

    def initialize(coachRepository, interactorOutput)
        @coachRepository = coachRepository
        @interactorOutput = interactorOutput
    end

    def addClientToCoach(reqModel)
        @coachRepository.doesClientExist(reqModel.clientId) {
            |doesClientExist, client| 
            doesClientExist ? clientExistsCheckCoach(client, reqModel.coachId) : clientDoesntExistError(reqModel)
        } 
    end

    def clientExistsCheckCoach(client, coachId)
        @coachRepository.doesCoachExist(coachId) {
            |doesCoachExist, coach| 
            doesCoachExist ? clientAndCoachExist(client, coach) : coachDoesntExistError(coachId)
        }
    end

    def clientAndCoachExist(client, coach)
        @coachRepository.isClientAClientOfThisCoach(client, coach){
            |isAlreadyAClient| !isAlreadyAClient ? validClientAndCoach(client, coach) : alreadyAClientError(client, coach)
        }
    end

    def validClientAndCoach(client, coach)
        @coachRepository.addClientToCoach(client, coach) {
                resModel = ResModel.new(coach.id, client.id, coach.name, client.name)
                @interactorOutput.presentAddedClientToCoach(resModel)
        } 
    end

    def clientDoesntExistError(reqModel)
        resModel = UnexistentClientResModel.new(reqModel.clientId)
         @interactorOutput.presentUnexistentClientError(resModel)
    end

    def coachDoesntExistError(coachId)
        resModel = UnexistentCoachResModel.new(coachId)
        @interactorOutput.presentUnexistentCoachError(resModel)
    end

    def alreadyAClientError(client, coach)
        resModel = AlreadyAClientResModel.new(client.id, client.name, coach.id, coach.name)
        @interactorOutput.presentAlreadyAClientError(resModel)
    end
    
end
