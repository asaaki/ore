require 'set'

module Ore
  class DocumentFile

    NAME = '.document'

    attr_reader :code_globs

    attr_reader :data_globs

    def initialize(path)
      @path = File.expand_path(path)

      @code_globs = Set[]
      @data_globs = Set[]

      @code_files = nil
      @extra_files = nil

      parse!
    end

    def code_files
      unless @code_files
        @code_files = Set[]

        @code_globs.each do |pattern|
          Dir.glob(pattern) { |path| @code_files << path }
        end
      end

      return @code_files
    end

    def extra_files
      unless @extra_files
        @extra_files = Set[]

        @extra_globs.each do |pattern|
          Dir.glob(pattern) { |path| @extra_files << path }
        end
      end

      return @extra_files
    end

    protected

    def parse!
      separator = false

      File.open(@path) do |file|
        file.each_line do |line|
          line = line.chomp.strip

          next if line.empty?

          unless separator
            if line == '-'
              separator = true
            else
              @code_globs << line
            end
          else
            @extra_globs << line
          end
        end
      end
    end

  end
end
