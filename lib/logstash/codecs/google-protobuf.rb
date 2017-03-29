# encoding: utf-8
require "logstash/codecs/base"
require "logstash/namespace"
require 'google/protobuf'

# TODO
class LogStash::Codecs::GoogleProtobuf < LogStash::Codecs::Base

  # The codec name
  config_name "google-protobuf"

  def register
    @lines = LogStash::Codecs::Line.new
    @lines.charset = "UTF-8"
  end # def register

  def decode(data)
    @lines.decode(data) do |line|
      replace = { "message" => line.get("message").to_s + 'append' }
      yield LogStash::Event.new(replace)
    end
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    event.get("message").to_s + 'append' + NL
  end # def encode_sync

end # class LogStash::Codecs::GoogleProtobuf
