#module Entities
class Client
    attr_accessor :email, :name

    def initialize(email, name)
        @email = email
        @name = name
    end
end
#end