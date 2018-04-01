class RepoSpy
    attr_reader :saveAppointmentCalled, :fetchAppointmentCalled

    def fetchAppointment(clientEmail, coachEmail, date)
        @fetchAppointmentCalled = true
        yield(clientEmail, coachEmail, Appointment.new("", date))
    end

    def saveAppointment(appointmentToSave)
        @saveAppointmentCalled = true
        yield()
    end
end

class RepoSpyCantFetch < RepoSpy
    attr_reader :saveAppointmentCalled, :fetchAppointmentCalled

    def fetchAppointment(clientEmail, coachEmail, date)
        @fetchAppointmentCalled = true
        raise(CannnotFetchAppointment, "Cannot fetch appointment for client #{clientEmail}, and coach #{coachEmail} on date #{date}")
    end
end

class RepoSpyUnexpectedError < RepoSpy
    def fetchAppointment(clientEmail, coachEmail, date)
        raise("")
    end
end

class PresenterSpy
    attr_accessor :presentFullfilledAppointmentCalled, :presentCannotFetchAppointmentCalled
    def presentFullfilledAppointment(resModel)
        @presentFullfilledAppointmentCalled = true
    end

    def presentCannotFetchAppointment(message)
        @presentCannotFetchAppointmentCalled = true
    end
end
