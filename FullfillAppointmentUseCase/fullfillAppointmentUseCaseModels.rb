class FullfillAppointmentUseCaseModels
    ReqModel = Struct.new(:clientId, :coachId, :date)
    ResModel = Struct.new(:clientId, :coachId, :date) 
end
