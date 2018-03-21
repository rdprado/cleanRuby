require 'test/unit'
require './CreateCoachUseCase/createCoachUseCaseInteractor'

class RepoSpy
    attr_reader :createCoachCalled

    def createCoach(coachToCreate) 
        @createCoachCalled = true
        yield(coachToCreate.email, coachToCreate.name)
    end
end

class CreateCoachPresenterSpy

    attr_reader :presentCreatedCoachCalled

    def presentCreatedCoach(resModel)
        @presentCreatedCoachCalled = true
    end
end

class CreateCoachUseCaseTest < Test::Unit::TestCase
    def testCreateCoachUseCaseShouldCallRepoAndInteractorOutput
        repo = RepoSpy.new
        interactorOutput = CreateCoachPresenterSpy.new
        interactorInput = CreateCoachUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.createCoachCalled)
        assert(!interactorOutput.presentCreatedCoachCalled)

        reqModel = CreateCoachUseCaseInteractor::ReqModel.new("julio@gmail.com", "Julio")
        interactorInput.createCoach(reqModel)

        assert(repo.createCoachCalled)
        assert(interactorOutput.presentCreatedCoachCalled)

    end
end