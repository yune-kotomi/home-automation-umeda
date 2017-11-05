require_relative 'listener/pushbullet'
require_relative 'executer/command'
require 'yaml'

if ARGV.empty?
  puts 'usage: bundle exec ruby umeda.rb config.yml'
else
  conf = YAML.load(open(ARGV[0]).read)

  EM.run do
    listeners = [Listener::Pushbullet.new]
    executer = Executer::Command.new(conf)

    listeners.each do |l|
      l.on_message do |message|
        puts "受信: #{message}"
        executer.execute(message)
      end
    end
  end
end
