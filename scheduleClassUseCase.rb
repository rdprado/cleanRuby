class ScheduleClassUseCase

    def initialize(classRepository, scheduleClassUseCaseOutputPort)
        @classRepository = classRepository
        @scheduleClassUseCaseOutputPort = scheduleClassUseCaseOutputPort
    end

    def scheduleClass(requestModel)
        isRequestValid = @classRepository.isClientAClientOfThisProfessor()
        if isRequestValid
            @classRepository.scheduleClass() { 
                |classID| @scheduleClassUseCaseOutputPort.presentClass(classID) 
            }
        end

    end
end