require './Entities/coach'

#module UseCases
class CreateCoachUseCaseInteractor

    ReqModel = Struct.new(:email, :name)
    ResModel = Struct.new(:email, :name)

    def initialize(repository, interactorOutput)
        @repository = repository
        @interactorOutput = interactorOutput
    end

    def createCoach(reqModel)
        coach = Coach.new(reqModel.email, reqModel.name)
        @repository.createCoach(coach) {
            |email, name|
            resModel = ResModel.new(email, name)
            @interactorOutput.presentCreatedCoach(resModel)
        }
    end
end
#end