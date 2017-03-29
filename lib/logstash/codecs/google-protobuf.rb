# encoding: utf-8
require "logstash/codecs/base"
require "logstash/namespace"
require 'google/protobuf'

# TODO
class LogStash::Codecs::GoogleProtobuf < LogStash::Codecs::Base

  # The codec name
  config_name "google-protobuf"

  # Name of the class to decode.
  # If your protobuf definition contains modules, prepend them to the class name with double colons like so:
  # [source,ruby]
  # class_name => "Foods::Dairy::Cheese"
  #
  # This corresponds to a protobuf definition starting as follows:
  # [source,ruby]
  # module Foods
  #    module Dairy
  #        class Cheese
  #            # here are your field definitions.
  #
  # If your class references other definitions: you only have to add the main class here.
  config :class_name, :validate => :string, :required => true

  # List of absolute pathes to files with protobuf definitions.
  # When using more than one file, make sure to arrange the files in reverse order of dependency so that each class is loaded before it is
  # refered to by another.
  #
  # Example: a class _Cheese_ referencing another protobuf class _Milk_
  # [source,ruby]
  # module Foods
  #   module Dairy
  #         class Cheese
  #            set_fully_qualified_name "Foods.Dairy.Cheese"
  #            optional ::Foods::Cheese::Milk, :milk, 1
  #            optional :int64, :unique_id, 2
  #            # here be more field definitions
  #
  # would be configured as
  # [source,ruby]
  # include_path => ['/path/to/protobuf/definitions/Milk.pb.rb','/path/to/protobuf/definitions/Cheese.pb.rb']
  #
  # When using the codec in an output plugin:
  # * make sure to include all the desired fields in the protobuf definition, including timestamp.
  #   Remove fields that are not part of the protobuf definition from the event by using the mutate filter.
  # * the @ symbol is currently not supported in field names when loading the protobuf definitions for encoding. Make sure to call the timestamp field "timestamp"
  #   instead of "@timestamp" in the protobuf file. Logstash event fields will be stripped of the leading @ before conversion.
  #
  config :include_path, :validate => :array, :required => true

  def register
    #@pb_metainfo = {}
    include_path.each { |path| require_pb_path(path) }
    @obj = create_object_from_name(class_name)
    @logger.debug("Protobuf files successfully loaded.")
  end # def register

  def decode(data)
    decoded = @obj.decode data
    results = decoded.to_h
    yield LogStash::Event.new(results) if block_given?
  end # def decode

  # TODO
  def encode_sync(event)
    nil
  end # def encode_sync

  private

  def create_object_from_name(name)
    begin
      @logger.debug("Creating instance of " + name)
      name.split('::').inject(Object) { |n,c| n.const_get c }
    end
  end

  def require_pb_path(dir_or_file)
    f = dir_or_file.end_with? ('.rb')
    begin
      if f
        @logger.debug("Including protobuf file: " + dir_or_file)
        require dir_or_file
      else
        Dir[ dir_or_file + '/*.rb'].each { |file|
          @logger.debug("Including protobuf path: " + dir_or_file + "/" + file)
          require file
        }
      end
    end
  end

end # class LogStash::Codecs::GoogleProtobuf
