module Executer
  class Command
    def initialize(conf)
      @conf = conf
    end

    def execute(message)
      @conf.select{|c| c[:command] }.each do |c|
        if c[:keywords].any? {|k| k.downcase.split(' ').all?{|w| message.downcase.include?(w) } }
          puts "コマンド実行: #{c[:name]}"
          system(c[:command])
        end
      end
    end
  end
end
