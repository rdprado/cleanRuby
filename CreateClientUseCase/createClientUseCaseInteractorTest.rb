require 'test/unit'
require './CreateClientUseCase/createClientUseCaseInteractor'

class RepoSpy
    attr_reader :createClientCalled

    def createClient(clientToCreate) 
        @createClientCalled = true
        yield(clientToCreate.email, clientToCreate.name)
    end
end

class CreateClientPresenterSpy

    attr_reader :presentCreatedClientCalled

    def presentCreatedClient(resModel)
        @presentCreatedClientCalled = true
    end
end

class CreateClientUseCaseTest < Test::Unit::TestCase
    def testCreateClientUseCaseShouldCallRepoAndInteractorOutput
        repo = RepoSpy.new
        interactorOutput = CreateClientPresenterSpy.new
        interactorInput = CreateClientUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.createClientCalled)
        assert(!interactorOutput.presentCreatedClientCalled)

        reqModel = CreateClientUseCaseInteractor::ReqModel.new("julio@gmail.com", "Julio")
        interactorInput.createClient(reqModel)

        assert(repo.createClientCalled)
        assert(interactorOutput.presentCreatedClientCalled)

    end
end