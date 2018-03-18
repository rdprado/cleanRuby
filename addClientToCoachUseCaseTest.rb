require 'test/unit'
require './addClientToCoachUseCase'
require './client'
require './coach'
#require Entities


class CoachRepositorySpy

    attr_reader :addClientToCoachCalled

    def isClientAClientOfThisCoach(clientId, coachId)
        return false
    end

    def coachExists(coachId)
        return true
    end

    def clientExists(clientId)
        return true
    end

    def addClientToCoach(clientId, coachId)
        @addClientToCoachCalled = true
        client = Client.new(clientId, "Joao")
        coach = Coach.new(coachId, "Marcos")
        yield(client, coach)
    end
end

class CoachRepositoryClientInvalidStub

    attr_reader :addClientToCoachCalled

    def isClientAClientOfThisCoach()
        return false
    end

    def coachExists(coachId)
        return true
    end

    def clientExists(clientId)
        return false
    end

    def addClientToCoach(clientId, coachId)
        @addClientToCoachCalled = true
    end
end

class CoachRepositoryCoachInvalidStub

    attr_reader :addClientToCoachCalled

    def isClientAClientOfThisCoach()
        return false
    end

    def coachExists(coachId)
        return true
    end

    def clientExists(clientId)
        return false
    end

    def addClientToCoach(clientId, coachId)
        @addClientToCoachCalled = true
    end
end

class CoachRepositoryCoachInvalidStub

    attr_reader :addClientToCoachCalled

    def isClientAClientOfThisCoach()
        return false
    end

    def coachExists(coachId)
        return false
    end

    def clientExists(clientId)
        return true
    end

    def addClientToCoach(clientId, coachId)
        @addClientToCoachCalled = true
    end
end

class AddClientToCoachPresenterSpy

    attr_reader :presentAddedClientToCoachCalled,
     :presentAlreadyAClientErrorCalled,
     :presentUnexistentClientErrorCalled,
     :presentUnexistentCoachErrorCalled

    def presentAddedClientToCoach(resModel)
        @presentAddedClientToCoachCalled = true
    end

    def presentAlreadyAClientError(resModel)
        @presentAlreadyAClientErrorCalled = true
    end

    def presentUnexistentClientError(resModel)
        @presentUnexistentClientErrorCalled = true
    end

    def presentUnexistentCoachError(resModel)
        @presentUnexistentCoachErrorCalled = true
    end
end

class CoachRepoAlreadyAClientStub

    attr_reader :addClientToCoachCalled
    def addClientToCoach()
        @addClientToCoachCalled = true
        yield "dd" "dd"
    end

    def isClientAClientOfThisCoach(clientId, coachId)
        return true
    end

    def coachExists(coachId)
        return true
    end

    def clientExists(clientId)
        return true
    end
end

class AddClientToCoachUseCaseTest < Test::Unit::TestCase
    def testAddClientToCoachUseCaseTestShouldCallCoachRepoAndOutput
        coachRepository = CoachRepositorySpy.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(coachRepository, presenter)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)

        
        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(coachRepository.addClientToCoachCalled)
        assert(presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)

    end

    def testShouldNotAddCLientWhenAlreadyAClient
        coachRepository = CoachRepoAlreadyAClientStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(coachRepository, presenter)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(presenter.presentAlreadyAClientErrorCalled)
    end

    def testShouldPresentErrorWhenClientDoesntExist
        coachRepository = CoachRepositoryClientInvalidStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(coachRepository, presenter)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(presenter.presentUnexistentClientErrorCalled)
    end

    def testShouldPresentErrorWhenCoach
        coachRepository = CoachRepositoryCoachInvalidStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(coachRepository, presenter)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!coachRepository.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)
        assert(presenter.presentUnexistentCoachErrorCalled)
    end
end

