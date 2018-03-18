class AddClientToCoachUseCase

    ReqModel = Struct.new(:coachId, :clientId)
    ResModel = Struct.new(:coachId, :clientId, :coachName, :clientName)

    AlreadyAClientResModel = Struct.new(:coachId, :clientId)
    UnexistentClientResModel = Struct.new(:clientId)
    UnexistentCoachResModel = Struct.new(:coachId)

    def initialize(coachRepository, interactorOutput)
        @coachRepository = coachRepository
        @interactorOutput = interactorOutput
    end

    def addClientToCoach(reqModel)
        @coachRepository.doesClientExist(reqModel.clientId) {
            |doesClientExist| doesClientExist ? clientExists(reqModel) : clientDoesntExistError(reqModel)
        } 
    end

    def clientExists(reqModel)
        @coachRepository.doesCoachExist(reqModel.coachId) {
            |doesCoachExist| doesCoachExist ? coachExists(reqModel) : coachDoesntExistError(reqModel)
        }
    end

    def coachExists(reqModel)
        @coachRepository.isClientAClientOfThisCoach(reqModel.clientId, reqModel.coachId){
            |isAlreadyAClient| !isAlreadyAClient ? validRequest(reqModel) : alreadyAClientError(reqModel)
        }
    end

    def validRequest(reqModel)
        @coachRepository.addClientToCoach(reqModel.clientId, reqModel.coachId) {
                |client, coach|
                resModel = ResModel.new(coach.id, client.id, coach.name, client.name)
                @interactorOutput.presentAddedClientToCoach(resModel)
        } 
    end

    def clientDoesntExistError(reqModel)
        resModel = UnexistentClientResModel.new(reqModel.clientId)
         @interactorOutput.presentUnexistentClientError(resModel)
    end

    def coachDoesntExistError(reqModel)
        resModel = UnexistentCoachResModel.new(reqModel.clientId)
        @interactorOutput.presentUnexistentCoachError(resModel)
    end

    def alreadyAClientError(reqModel)
        resModel = AlreadyAClientResModel.new(reqModel.clientId)
        @interactorOutput.presentAlreadyAClientError(resModel)
    end
    
end
