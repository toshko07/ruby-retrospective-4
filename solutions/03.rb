module RBFS

  class File
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data
      when String  then :string
      when Symbol  then :symbol
      when Numeric then :number
      when nil     then :nil
      else              :boolean
      end
    end

    def serialize
      "#{data_type}:#{@data.to_s}"
    end

    def self.parse(string_data = nil)
      data = parse_data *string_data.split(':', 2)

      File.new data
    end

    def self.parse_data(type, data)
      case type
      when 'nil'     then nil
      when 'string'  then data
      when 'number'  then parse_number(data)
      when 'symbol'  then data.to_sym
      else                data == 'true'
      end
    end

    def self.parse_number(data)
      if data.include? '.'
        data.to_f
      else
        data.to_i
      end
    end
  end

  class Directory
    attr_accessor :directories, :files

    def initialize
      @directories = {}
      @files = {}
    end

    def add_file(name, file)
        @files[name] = file
    end

    def add_directory(name, directory = nil)
      if directory.nil?
        @directories[name] = RBFS::Directory.new
      else
        @directories[name] = directory
      end
    end

    def [](name)
      if @directories.has_key?(name)
        @directories[name]
      elsif @files.has_key?(name)
        @files[name]
      else
        nil
      end

    end

    def serialize
      data = @files.size.to_s + ":"
      @files.each do |key, val|
        data += key.to_s + ":" + val.serialize.size.to_s + ":" + val.serialize
      end
      data += @directories.size.to_s + ":"
      @directories.each do |key, val|
        data += key.to_s + ":" + val.serialize.size.to_s + ":" + val.serialize
      end
      data
    end

    def self.parse(data)
      directory = new

      DirectoryParser.new(data, directory).run

      directory
    end
  end

  class DirectoryParser
    def initialize(string, directory)
      @string = string
      @directory = directory
    end

    def run
      each(File) do |name, object|
        @directory.add_file(name, object)
      end
      each(Directory) do |name, object|
        @directory.add_directory(name, object)
      end
    end

    def each(type_class)
      hash_size, @string = @string.split(':', 2)
      hash_size.to_i.times do
        yield parse_named_object(type_class)
      end
    end

    def parse_named_object(type_class)
      name, size, @string = @string.split(':', 3)
      size = size.to_i
      current_string, @string = [@string[0..size - 1], \
      @string[size..-1]]
      [name, type_class.parse(current_string)]
    end
  end
end
