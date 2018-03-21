require 'test/unit'
require './FullfillAppointmentUseCase/fullfillAppointmentUseCaseInteractor'
require './FullfillAppointmentUseCase/fullfillAppointmentDataErrors'
require './FullfillAppointmentUseCase/fullfillAppointmentUseCaseModels'
require './Entities/appointment'

class RepoSpy
    attr_accessor :saveAppointmentCalled

    def fetchAppointment(clientId, coachId, date)
        @saveAppointmentCalled = true
        yield(clientId, coachId, Appointment.new("", date))
    end

    def saveAppointment(appointmentToSave)
        @saveAppointmentCalled = true
        yield()
    end
end

class RepoSpyCantFetch < RepoSpy
    def fetchAppointment(clientId, coachId, date)
        raise(CannnotFetchAppointment, "Cannot fetch appointment for client #{clientId}, and coach #{coachId} on date #{date}")
    end
end

class PresenterSpy
    attr_accessor :presentFullfilledAppointmentCalled, :presentCannotFetchAppointmentCalled
    def presentFullfilledAppointment(resModel)
        @presentFullfilledAppointmentCalled = true
    end

    def presentCannotFetchAppointment(message)
        @presentCannotFetchAppointmentCalled = true
    end
end

class CreateCoachUseCaseTest < Test::Unit::TestCase
    def testFullfillAppointmentShouldCallRepoAndInteractorOutput
        interactorOutput = PresenterSpy.new
        repo = RepoSpy.new 
        interactorInput = FullfillAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.saveAppointmentCalled)
        assert(!interactorOutput.presentFullfilledAppointmentCalled)
        reqModel = FullfillAppointmentUseCaseModels::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        interactorInput.fullfillAppointment(reqModel)
        assert(repo.saveAppointmentCalled)
        assert(interactorOutput.presentFullfilledAppointmentCalled)

    end

    def testFullfillAppointmentShouldCallAppointErrorWhenFetchThrows
        interactorOutput = PresenterSpy.new
        repo = RepoSpyCantFetch.new 
        interactorInput = FullfillAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.saveAppointmentCalled)
        assert(!interactorOutput.presentFullfilledAppointmentCalled)
        reqModel = FullfillAppointmentUseCaseModels::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        #assert_raise do
        interactorInput.fullfillAppointment(reqModel)
        assert(interactorOutput.presentCannotFetchAppointmentCalled)
        #end
    end
end

