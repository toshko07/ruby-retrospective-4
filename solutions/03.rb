module RBFS

  class File
    attr_accessor :data, :data_type

    def initialize(data = nil)
      @data = data
      if    @data.is_a?  String    then @data_type = :string
      elsif @data.is_a? Symbol     then @data_type = :symbol
      elsif @data.is_a? Fixnum     then @data_type = :number
      elsif @data.is_a? Float      then @data_type = :number
      elsif @data.is_a? TrueClass  then @data_type = :boolean
      elsif @data.is_a? FalseClass then @data_type = :boolean
      else                              @data_type = data
      end
    end

    def serialize
      @file_serialize = "#{@data_type.to_s}:#{@data}"
    end

    def self.parse(string_data = nil)
      data_type = string_data.split(":")[0]
      data = string_data.split(":")[1]
      if data_type == "symbol"     then File.new(data.to_sym)
      elsif data_type == "string"  then File.new data
      elsif data_type == "number"  then File.new(data.to_i)
      elsif data_type == "boolean" then File.new(data == "true")
      elsif  data.include?"."      then File.new(data.to_f)
      else                              File.new
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
      return_data = @files.size.to_s + ":"
      @files.each do |key, value|
        return_data += key.to_s + ":" + value.serialize.size.to_s + ":" + value.serialize
      end
      return_data += @directories.size.to_s + ":"
      @directories.each do |key, value|
        return_data += key.to_s + ":" + value.serialize.size.to_s + ":" + value.serialize
      end
      return_data
    end

  end

end
