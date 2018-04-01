class FullfillAppointmentUseCaseModels
    ReqModel = Struct.new(:clientEmail, :coachEmail, :date)
    ResModel = Struct.new(:clientEmail, :coachEmail, :date) 
end
