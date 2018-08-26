require 'test/unit'
require './UseCases/AddClientToCoach/addClientToCoachUseCase'
require './Entities/client'
require './Entities/coach'

require_relative 'mocks'
#require Entities

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

        assert(repo.addClientToCoachCalled)
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

