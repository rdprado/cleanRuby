class Appointment

    attr_accessor :date, :title

    def initialize(date, title)
        @date = date
        @title = title
    end

    def fullfill()
        @fullfilled = true
    end
end
