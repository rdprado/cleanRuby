require 'test/unit'
require './AddClientToCoachUseCase/addClientToCoachUseCase'
require './Entities/client'
require './Entities/coach'
#require Entities

class RepoSpy

    attr_reader :addClientToCoachCalled

    def isClientAClientOfThisCoach(client, coach)
        yield(false)
    end

    def doesCoachExist(coachId)
        yield(true, Coach.new(coachId, "Marcos"))
    end

    def doesClientExist(clientId)
        yield(true, Client.new(clientId, "Joao"))
    end

    def addClientToCoach(client, coach)
        @addClientToCoachCalled = true
        yield
    end
end


class RepoInvalidClientStub < RepoSpy
    def doesClientExist(clientId)
        yield(false, nil)
    end
end

class RepoInvalidCoachStub < RepoSpy
    def doesCoachExist(coachId)
        yield(false, nil)
    end
end

class RepoAlreadyAClientStub < RepoSpy
    def isClientAClientOfThisCoach(client, coach)
        yield(true)
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

class AddClientToCoachUseCaseTest < Test::Unit::TestCase
    def testAddClientToCoachUseCaseTestShouldCallCoachRepoAndOutput
        repo = RepoSpy.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(repo, presenter)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(repo.addClientToCoachCalled)
        assert(presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
    end

    def testShouldNotAddCLientWhenAlreadyAClient
        repo = RepoAlreadyAClientStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(repo, presenter)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(presenter.presentAlreadyAClientErrorCalled)
    end

    def testShouldPresentErrorWhenClientDoesntExist
        repo = RepoInvalidClientStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(repo, presenter)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(presenter.presentUnexistentClientErrorCalled)
    end

    def testShouldPresentErrorWhenCoachDoesNotExist
        repo = RepoInvalidCoachStub.new
        presenter = AddClientToCoachPresenterSpy.new
        addClientToCoachUseCase = AddClientToCoachUseCase.new(repo, presenter)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)
        assert(!presenter.presentUnexistentCoachErrorCalled)

        reqModel = AddClientToCoachUseCase::ReqModel.new("junim@gmail.com", "lalalau@gmail.com")
        addClientToCoachUseCase.addClientToCoach(reqModel)

        assert(!repo.addClientToCoachCalled)
        assert(!presenter.presentAddedClientToCoachCalled)
        assert(!presenter.presentAlreadyAClientErrorCalled)
        assert(!presenter.presentUnexistentClientErrorCalled)
        assert(presenter.presentUnexistentCoachErrorCalled)
    end
end

