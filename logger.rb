require 'logger'

#module CleanRuby
class Logger

    @@instance = ::Logger.new(STDOUT)

    def self.error(message)
        @@instance.error(message)
    end

    def self.info(mesage)
        @@instance.info(message)
    end

    def self.setLogger(logger)
        @@instance = logger
    end
    private_class_method :new
end
#end