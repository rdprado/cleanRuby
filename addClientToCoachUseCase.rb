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


        if !@coachRepository.clientExists(reqModel.clientId) {
            |clientExists|
            if !clientExists
                resModel = UnexistentClientResModel.new(reqModel.clientId)
                @interactorOutput.presentUnexistentClientError(resModel)
            elsif !@coachRepository.coachExists(reqModel.coachId)
                resModel = UnexistentCoachResModel.new(reqModel.clientId)
                @interactorOutput.presentUnexistentCoachError(resModel)
            elsif @coachRepository.isClientAClientOfThisCoach(reqModel.clientId, reqModel.coachId)
                resModel = AlreadyAClientResModel.new(reqModel.clientId)
                @interactorOutput.presentAlreadyAClientError(resModel)
            else
                @coachRepository.addClientToCoach(reqModel.clientId, reqModel.coachId) {
                    |client, coach|
                    resModel = ResModel.new(coach.id, client.id, coach.name, client.name)
                    @interactorOutput.presentAddedClientToCoach(resModel)
                }
            end
        } 
        end


        # if !@coachRepository.clientExists(reqModel.clientId) 
        #     resModel = UnexistentClientResModel.new(reqModel.clientId)
        #     @interactorOutput.presentUnexistentClientError(resModel)
        #     return
        # elsif !@coachRepository.coachExists(reqModel.coachId)
        #     resModel = UnexistentCoachResModel.new(reqModel.clientId)
        #     @interactorOutput.presentUnexistentCoachError(resModel)
        #     return
        # elsif @coachRepository.isClientAClientOfThisCoach(reqModel.clientId, reqModel.coachId)
        #     resModel = AlreadyAClientResModel.new(reqModel.clientId)
        #     @interactorOutput.presentAlreadyAClientError(resModel)
        #     return
        # end

        # @coachRepository.addClientToCoach(reqModel.clientId, reqModel.coachId) {
        #             |client, coach|
        #             resModel = ResModel.new(coach.id, client.id, coach.name, client.name)
        #             @interactorOutput.presentAddedClientToCoach(resModel)
        # }
    end
end
