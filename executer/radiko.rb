require 'selenium-webdriver'

module Executer
  class Radiko
    def initialize(conf)
      @conf = conf.select{|c| c[:radiko] }
    end

    def execute(message)
      @conf.each do |c|
        if c[:keywords].any? {|k| k.downcase.split(' ').all?{|w| message.downcase.include?(w) } }
          puts "Radiko実行: #{c[:name]}"
          sleep 10
          station = c[:radiko]

          caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {args: ["--disable-gpu", "user-data-dir=#{Dir.pwd}/profile"]})
          driver = Selenium::WebDriver.for(:chrome, :desired_capabilities => caps)
          driver.navigate.to("http://radiko.jp/#!/live/#{station}")
          sleep 2
          driver.find_element(:css, '.play-radio.btn--play').click
        end
      end
    end
  end
end
