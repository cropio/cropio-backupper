require 'logger'

class Log
  attr_reader :logger
  def initialize
    @logger = Logger.new(STDOUT)

    logger.formatter = proc do |severity, datetime, _progname, msg|
      date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      if severity == "INFO"
        "[#{date_format}] #{msg}\r"
      else
        "[#{date_format}] #{msg}\n"
      end
    end
  end

  def print_on_same_line(text)
    logger.info text
  end

  def print(text)
    logger.debug text
  end
end
