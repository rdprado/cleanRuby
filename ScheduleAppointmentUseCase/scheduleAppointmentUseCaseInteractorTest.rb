require 'test/unit'
require './ScheduleAppointmentUseCase/scheduleAppointmentUseCaseInteractor'

class RepoSpy
    attr_reader :scheduleAppointmentCalled

    def isClientAClientOfThisCoach()
        yield(true)
    end

    def scheduleAppointment(appointmentToSchedule) 
        @scheduleAppointmentCalled = true
        yield("", "", "", "", "", "")
    end
end

class InvalidClientStub < RepoSpy
    def isClientAClientOfThisCoach()
        yield(false)
    end
end

class ScheduleAppointmentPresenterSpy
    attr_reader :presentAppointmentCalled, :presentNotAClientOfProfessorErrorCalled
    def presentAppointment(resModel) 
        @presentAppointmentCalled = true
    end
    def presentNotAClientOfProfessorError(resModel) 
        @presentNotAClientOfProfessorErrorCalled = true
    end
end

class ScheduleAppointmentUseCaseTest < Test::Unit::TestCase
    def testScheduleAppointmentShouldCallAppointmentRepoAndUseCaseOutput
        appointmentRepository = RepoSpy.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCaseInteractor.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        assert(!appointmentRepository.scheduleAppointmentCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(appointmentRepository.scheduleAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentNotAClientOfProfessorErrorCalled)
    end

    def testScheduleAppointmentShouldNotPresentAppointmentWhenCLientNotACLientOfcoach
        appointmentRepository = InvalidClientStub.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCaseInteractor.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        assert(!appointmentRepository.scheduleAppointmentCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(!appointmentRepository.scheduleAppointmentCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentNotAClientOfProfessorErrorCalled)
    end

end

