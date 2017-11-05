require 'websocket-eventmachine-client'
require 'pushbullet_ruby'

module Listener
  class Pushbullet
    def initialize
      @client = PushbulletRuby::Client.new(PushbulletRuby::Token.load)
      @on_message = []
      connect

      # 接続が切れていたら繋ぎ直す
      EM.add_periodic_timer(5) do
        if Time.now - @last_nop > 32
          puts 'reconnect by timer'
          @websocket.close
          connect
          retrieve
        end
      end
    end

    def on_message(&block)
      @on_message.push(block)
    end

    private
    def connect
      ws = WebSocket::EventMachine::Client.connect(:uri => "wss://stream.pushbullet.com/websocket/#{@client.key}")

      ws.onmessage do |msg|
        data = JSON.parse(msg)
        case data['type']
        when 'tickle'
          retrieve if data['subtype'] == 'push'
        when 'nop'
          @last_nop = Time.now
        end
      end

      @websocket = ws
    rescue => e
      p e
      # do nothing
    end

    def retrieve
      push = @client.pushes.first
      if push.body['title'] == 'Google Assistant Commands' && Time.now - push.created < 60 && push.body['iden'] != @last_iden
        @on_message.each{|h| h.call(push.body['body']) }
        @last_iden = push.body['iden']
        push.update(:client => @client, :params => {:dismissed => true})
      end
    rescue => e
      p e
      # do nothing
    end
  end
end
