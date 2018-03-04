require 'test/unit'
require './scheduleAppointmentUseCase'

class AppointmentRepoInvalidClientStub
    def isClientAClientOfThisProfessor()
        return false
    end
end

class AppointmentRepoSpy
    attr_reader :scheduleAppointmentCalled, :isClientAClientOfThisProfessorCalled, :isDateAvailableCalled

    def isClientAClientOfThisProfessor()
        @isClientAClientOfThisProfessorCalled = true
        return true
    end

    def scheduleAppointment(appointmentToSchedule) 
        @scheduleAppointmentCalled = true
        yield "00030310"
    end
end

class ScheduleAppointmentPresenterSpy
    attr_reader :presentAppointmentCalled, :presentErrorCalled
    def presentAppointment(appointmentId) 
        @presentAppointmentCalled = true
    end
    def presentError(errorTitle, errorMsg) 
        @presentErrorCalled = true
    end
end

class ScheduleAppointmentUseCaseTest < Test::Unit::TestCase
    def testScheduleAppointmentShouldCallAppointmentRepoAndUseCaseOutput
        appointmentRepository = AppointmentRepoSpy.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCase.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        assert(!appointmentRepository.scheduleAppointmentCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(!appointmentRepository.isClientAClientOfThisProfessorCalled)

        Struct.new("ReqModel", :professorId, :clientId, :date)
        reqModel = Struct::ReqModel.new("junim@gmail.com", "lalalau@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(appointmentRepository.scheduleAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(appointmentRepository.isClientAClientOfThisProfessorCalled)
        assert(!scheduleAppointmentUseCaseOutputPort.presentErrorCalled)
    end

    def testScheduleAppointmentShouldNotPresentAppointmentWhenCLientNotACLientOfProfessor
        appointmentRepository = AppointmentRepoInvalidClientStub.new
        scheduleAppointmentUseCaseOutputPort = ScheduleAppointmentPresenterSpy.new
        scheduleAppointmentUseCase = ScheduleAppointmentUseCase.new(appointmentRepository, scheduleAppointmentUseCaseOutputPort)

        Struct.new("ReqModel", :professorId, :clientId, :date)
        reqModel = Struct::ReqModel.new("junim@gmail.com", "jose@gmail.com", "")
        scheduleAppointmentUseCase.scheduleAppointment(reqModel)

        assert(!scheduleAppointmentUseCaseOutputPort.presentAppointmentCalled)
        assert(scheduleAppointmentUseCaseOutputPort.presentErrorCalled)
    end

end

