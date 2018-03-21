require 'test/unit'
require './FullfillAppointmentUseCase/fullfillAppointmentUseCaseInteractor'
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

class PresenterSpy
    attr_accessor :presentFullfilledAppointmentCalled
    def presentFullfilledAppointment(resModel)
        @presentFullfilledAppointmentCalled = true
    end
end

class CreateCoachUseCaseTest < Test::Unit::TestCase
    def testFullfillAppointmentShouldCallRepoAndInteractorOutput
        interactorOutput = PresenterSpy.new
        repo = RepoSpy.new 
        interactorInput = FullfillAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.saveAppointmentCalled)
        assert(!interactorOutput.presentFullfilledAppointmentCalled)

        reqModel = FullfillAppointmentUseCaseInteractor::ReqModel.new("client@gmail.com", "coach@gmail.com", "date")
        interactorInput.fullfillAppointment(reqModel)
        assert(repo.saveAppointmentCalled)
        assert(interactorOutput.presentFullfilledAppointmentCalled)

    end
end