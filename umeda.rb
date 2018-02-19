require_relative 'listener/pushbullet'
require_relative 'executer/command'
require_relative 'executer/radiko'
require 'yaml'

if ARGV.empty?
  puts 'usage: bundle exec ruby umeda.rb config.yml'
else
  conf = YAML.load(open(ARGV[0]).read)

  EM.run do
    listeners = [Listener::Pushbullet.new]
    command_executer = Executer::Command.new(conf)
    radiko_executer = Executer::Radiko.new(conf)

    listeners.each do |l|
      l.on_message do |message|
        puts "受信: #{message}"
        command_executer.execute(message)
        radiko_executer.execute(message)
      end
    end
  end
end
