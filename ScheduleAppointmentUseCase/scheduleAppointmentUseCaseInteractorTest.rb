require 'test/unit'
require './ScheduleAppointmentUseCase/scheduleAppointmentUseCaseInteractor'
require './Entities/client'
require './Entities/coach'

class RepoSpy
    attr_reader :scheduleAppointmentCalled

    def isClientAClientOfThisCoach(client, coach)
        yield(true)
    end

    def scheduleAppointment(appointmentToSchedule) 
        @scheduleAppointmentCalled = true
        yield("", "", "", "", "", "")
    end

    def doesCoachExist(coachEmail)
        yield(true, Coach.new(coachEmail, "Marcos"))
    end

    def doesClientExist(email)
        yield(true, Client.new(email, "Joao"))
    end
end

class RepoUnexistentClientStub < RepoSpy
    def doesClientExist(email)
        yield(false, nil)
    end 
end

class RepoUnexistentCoachStub < RepoSpy
    def isClientAClientOfThisCoach()
        yield(true)
    end

    def doesCoachExist(coachEmail)
        yield(false, nil)
    end
end

class NotAClientStub < RepoSpy
    def isClientAClientOfThisCoach(client, coach)
        yield(false)
    end
end

class ScheduleAppointmentPresenterSpy
    attr_reader :presentAppointmentCalled, 
    :presentNotAClientOfProfessorErrorCalled,
    :presentUnexistentClientErrorCalled
    def presentAppointment(resModel) 
        @presentAppointmentCalled = true
    end
    def presentNotAClientOfProfessorError(resModel) 
        @presentNotAClientOfProfessorErrorCalled = true
    end

    def presentUnexistentClientError(resModel) 
        @presentUnexistentClientErrorCalled = true
    end
end

class ScheduleAppointmentUseCaseTest < Test::Unit::TestCase
    def testScheduleAppointmentShouldCallAppointmentRepoAndUseCaseOutput
        repo = RepoSpy.new
        interactorOutput = ScheduleAppointmentPresenterSpy.new
        interactornInput = ScheduleAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.scheduleAppointmentCalled)
        assert(!interactorOutput.presentAppointmentCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "21/10", "malhar")
        interactornInput.scheduleAppointment(reqModel)

        assert(repo.scheduleAppointmentCalled)
        assert(interactorOutput.presentAppointmentCalled)
        assert(!interactorOutput.presentNotAClientOfProfessorErrorCalled)
    end

    def testScheduleAppointmentShouldNotPresentAppointmentWhenCLientNotACLientOfcoach
        repo = NotAClientStub.new
        interactorOutput = ScheduleAppointmentPresenterSpy.new
        interactornInput = ScheduleAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.scheduleAppointmentCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "21/10", "malhar")
        interactornInput.scheduleAppointment(reqModel)

        assert(!repo.scheduleAppointmentCalled)
        assert(!interactorOutput.presentAppointmentCalled)
        assert(interactorOutput.presentNotAClientOfProfessorErrorCalled)
    end

    def testShouldPresentErrorWhenClientDoesntExist
        repo = RepoUnexistentClientStub.new
        interactorOutput = ScheduleAppointmentPresenterSpy.new
        interactornInput = ScheduleAppointmentUseCaseInteractor.new(repo, interactorOutput)

        assert(!repo.scheduleAppointmentCalled)
        assert(!interactorOutput.presentAppointmentCalled)
        assert(!interactorOutput.presentNotAClientOfProfessorErrorCalled)
        assert(!interactorOutput.presentUnexistentClientErrorCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "21/10", "malhar")
        interactornInput.scheduleAppointment(reqModel)

        assert(!repo.scheduleAppointmentCalled)
        assert(!interactorOutput.presentNotAClientOfProfessorErrorCalled)
        assert(interactorOutput.presentUnexistentClientErrorCalled)
    end

end

