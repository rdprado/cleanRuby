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
        @coachRepository.fetchClient(reqModel.clientEmail) {
            |client, error|
            if error == :noError
                validClient(client, reqModel.coachEmail)
            else
                clientDoesntExistError(reqModel.clientEmail)
            end
        } 
    end

    def validClient(client, coachEmail)
        @coachRepository.fetchCoach(coachEmail) {
            |coach, error| 
            if error == :noError
                validCoach(client, coach)
            else
                coachDoesntExistError(coachEmail)
            end
        }
    end

    def validCoach(client, coach)
        @coachRepository.addClientToCoach(client, coach) {
            |error|
            if error == :noError
                resModel = ResModel.new(client.email, client.name, coach.email, coach.name)
                @interactorOutput.presentAddedClientToCoach(resModel)
            else
                alreadyAClientError(client, coach)
            end
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
