require 'test/unit'
require './scheduleAppointmentUseCaseInteractor'

class AppointmentRepoInvalidClientStub
    def isClientAClientOfThisCoach()
        yield(false)
    end
end


class AppointmentRepoSpy
    attr_reader :scheduleAppointmentCalled, :isClientAClientOfThisCoachCalled, :isDateAvailableCalled

    def isClientAClientOfThisCoach()
        @isClientAClientOfThisCoachCalled = true
        yield(true)
    end

    def scheduleAppointment(appointmentToSchedule) 
        @scheduleAppointmentCalled = true
        yield("", "", "", "", "", "")
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
        appointmentRepository = AppointmentRepoSpy.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCaseInteractor.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        assert(!appointmentRepository.scheduleAppointmentCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(!appointmentRepository.isClientAClientOfThisCoachCalled)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(appointmentRepository.scheduleAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(appointmentRepository.isClientAClientOfThisCoachCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentNotAClientOfProfessorErrorCalled)
    end

    def testScheduleAppointmentShouldNotPresentAppointmentWhenCLientNotACLientOfcoach
        appointmentRepository = AppointmentRepoInvalidClientStub.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCaseInteractor.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        reqModel = ScheduleAppointmentUseCaseInteractor::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentNotAClientOfProfessorErrorCalled)
    end

end

