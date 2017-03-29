# encoding: utf-8
require_relative '../spec_helper'
require "logstash/codecs/google-protobuf"

describe LogStash::Codecs::GoogleProtobuf do

  context "#decode" do
    let(:plugin_wink_event) do
      LogStash::Codecs::GoogleProtobuf.new("class_name" => "Com::Test::Package::WinkEvent", "include_path" => ['spec/helpers/WinkEvents_pb.rb'])
    end
    before do
      plugin_wink_event.register
    end

    it "should return an event from protobuf encoded data" do
      inspected_class = Com::Test::Package::WinkEvent
      inspected_enum = Com::Test::Package::EyeColor

      data = {
          timestamp: 1490803733123,
          eye_color: inspected_enum::BLUE,
          duration: 3,
          is_pretty: true,
          impression: "sexy",
      }
      msg = inspected_class.new(data)
      proto_data = inspected_class.encode(msg)

      plugin_wink_event.decode(proto_data) do |event|
        expect(event.get("timestamp")).to eq(data[:timestamp])
        expect(event.get("eye_color")).to eq(inspected_enum.lookup(data[:eye_color]))
        expect(event.get("duration")).to eq(data[:duration])
        expect(event.get("is_pretty")).to eq(data[:is_pretty])
        expect(event.get("impression")).to eq(data[:impression])
      end
    end
  end

end