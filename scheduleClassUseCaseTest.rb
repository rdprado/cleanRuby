require 'test/unit'
require './scheduleClassUseCase'

class ClassRepoInvalidClientRequestStub
    attr_reader :scheduleClassCalled

    def isClientAClientOfThisProfessor
        return false
    end

    def scheduleClass() 
        @scheduleClassCalled = true
    end
end

class ClassRepoUnavailableDateRequestStub
    attr_reader :scheduleClassCalled

    def isClientAClientOfThisProfessor
        return true
    end

    def scheduleClass() 
        @scheduleClassCalled = true
    end
end

class ClassRepoSpy
    attr_reader :scheduleClassCalled, :isClientAClientOfThisProfessorCalled, :isDateAvailableCalled

    def isClientAClientOfThisProfessor
        @isClientAClientOfThisProfessorCalled = true
    end

    def scheduleClass() 
        @scheduleClassCalled = true
        yield "!!!!!"
    end
end

class ScheduleClassPresenterSpy
    attr_reader :presentClassCalled
    def presentClass() 
        @presentClassCalled = true
    end
end

class ScheduleClassUseCaseTest < Test::Unit::TestCase
    def testScheduleClassShouldCallClassRepoAndUseCaseOutput
        classRepository = ClassRepoSpy.new
        scheduleClassUseCaseOutputPort = ScheduleClassPresenterSpy.new
        scheduleClassUseCase = ScheduleClassUseCase.new(classRepository, scheduleClassUseCaseOutputPort)

        assert(!classRepository.scheduleClassCalled)
        assert(!scheduleClassUseCaseOutputPort.presentClassCalled)
        assert(!classRepository.isClientAClientOfThisProfessorCalled)

        scheduleClassUseCase.scheduleClass(nil)

        assert(classRepository.scheduleClassCalled)
        assert(scheduleClassUseCaseOutputPort.presentClassCalled)
        assert(classRepository.isClientAClientOfThisProfessorCalled)
    end

    def testScheduleClassShouldNotPresentClassWhenCLientNotACLientOfProfessor
        classRepository = ClassRepoInvalidClientRequestStub.new
        scheduleClassUseCaseOutputPort = ScheduleClassPresenterSpy.new
        scheduleClassUseCase = ScheduleClassUseCase.new(classRepository, scheduleClassUseCaseOutputPort)

        assert(!classRepository.scheduleClassCalled)

        scheduleClassUseCase.scheduleClass(nil)
        assert(!classRepository.scheduleClassCalled)
        assert(!scheduleClassUseCaseOutputPort.presentClassCalled)
    end

end

