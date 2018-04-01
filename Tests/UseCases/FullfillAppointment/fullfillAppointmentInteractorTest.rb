require 'test/unit'
require './UseCases/FullfillAppointment/fullfillAppointmentUseCaseInteractor'
require './UseCases/FullfillAppointment/fullfillAppointmentDataErrors'
require './UseCases/FullfillAppointment/fullfillAppointmentUseCaseModels'
require './Entities/appointment'

require_relative 'mocks'

class FullfillAppointmentUseCaseTest < Test::Unit::TestCase
    def setup()
        @repoSpy = RepoSpy.new
        @repoSpyCantFetch = RepoSpyCantFetch.new
        @repoSpyUnexpectedError = RepoSpyUnexpectedError.new
        @presenterSpy = PresenterSpy.new
    end

    def testFullfillAppointmentShouldCallRepoAndInteractorOutput
        interactorInput = FullfillAppointmentUseCaseInteractor.new(@repoSpy, @presenterSpy)

        assert(!@repoSpy.fetchAppointmentCalled)
        assert(!@repoSpy.saveAppointmentCalled)
        assert(!@presenterSpy.presentFullfilledAppointmentCalled)
        reqModel = FullfillAppointmentUseCaseModels::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        interactorInput.fullfillAppointment(reqModel)
        assert(@repoSpy.fetchAppointmentCalled)
        assert(@repoSpy.saveAppointmentCalled)
        assert(@presenterSpy.presentFullfilledAppointmentCalled)
    end

    def testFullfillAppointmentShouldRescueWhenRepoCannotFetch
        interactorInput = FullfillAppointmentUseCaseInteractor.new(@repoSpyCantFetch, @presenterSpy)

        assert(!@repoSpyCantFetch.fetchAppointmentCalled)
        assert(!@repoSpyCantFetch.saveAppointmentCalled)
        assert(!@presenterSpy.presentFullfilledAppointmentCalled)
        reqModel = FullfillAppointmentUseCaseModels::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        interactorInput.fullfillAppointment(reqModel)
        assert(@repoSpyCantFetch.fetchAppointmentCalled)
        assert(!@repoSpyCantFetch.saveAppointmentCalled)
        assert(@presenterSpy.presentCannotFetchAppointmentCalled)
    end

    def testFullfillAppointmentShouldRescueAndLog
        interactorInput = FullfillAppointmentUseCaseInteractor.new(@repoSpyUnexpectedError, @presenterSpy)

        reqModel = FullfillAppointmentUseCaseModels::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        interactorInput.fullfillAppointment(reqModel)
    end
end

