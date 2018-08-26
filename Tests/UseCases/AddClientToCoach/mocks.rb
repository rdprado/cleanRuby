class RepoSpy

    attr_reader :addClientToCoachCalled

    def fetchClient(email)
        yield(Client.new(email, "Joao"), :noErrors)
    end

    def fetchCoach(email)
        yield(Coach.new(email, "Marcos"), :noErrors)
    end
    
    def addClientToCoach(client, coach)
        @addClientToCoachCalled = true
        yield(:noErrors)
    end
end


class RepoInvalidClientStub < RepoSpy
    def fetchClient(email)
        yield(Client.new(email, "Joao"), :cannotFetch)
    end
end

class RepoInvalidCoachStub < RepoSpy
    def fetchCoach(email)
        yield(Coach.new(email, "Marcos"), :cannotFetch)
    end
end

class RepoAlreadyAClientStub < RepoSpy
    def addClientToCoach(client, coach)
        @addClientToCoachCalled = true
        yield(:cannotAdd)
    end
end

class AddClientToCoachPresenterSpy

    attr_reader :presentAddedClientToCoachCalled,
     :presentAlreadyAClientErrorCalled,
     :presentUnexistentClientErrorCalled,
     :presentUnexistentCoachErrorCalled

    def presentAddedClientToCoach(resModel)
        @presentAddedClientToCoachCalled = true
    end

    def presentAlreadyAClientError(resModel)
        @presentAlreadyAClientErrorCalled = true
    end

    def presentUnexistentClientError(resModel)
        @presentUnexistentClientErrorCalled = true
    end

    def presentUnexistentCoachError(resModel)
        @presentUnexistentCoachErrorCalled = true
    end
end