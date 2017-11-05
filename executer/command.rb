module Executer
  class Command
    def initialize(conf)
      @conf = conf
    end

    def execute(message)
      @conf.each do |c|
        if c[:keywords].any? {|k| k.downcase.split(' ').all?{|w| message.downcase.include?(w) } }
          puts "実行: #{c[:name]}"
          system(c[:command])
        end
      end
    end
  end
end
