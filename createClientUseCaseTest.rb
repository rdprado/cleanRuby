require 'test/unit'
require './createClientUseCase'

class CreateClientUseCaseTest < Test::Unit::TestCase
    def testFail
        createClientUC = CreateClientUseCase.new
        createClientUC.createClient("Edvaldson")
    end
end