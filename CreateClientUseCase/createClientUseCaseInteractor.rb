require './Entities/client'

#module UseCases
class CreateClientUseCaseInteractor

    ReqModel = Struct.new(:email, :name)
    ResModel = Struct.new(:email, :name)

    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def createClient(reqModel)
        client = Client.new(reqModel.email, reqModel.name)
        @repository.createClient(client) {
            |email, name|
            resModel = ResModel.new(email, name)
            @interactorOutput.presentCreatedClient(resModel)
        }
    end
end
#end