module GitGPG
  module Git
    class Attributes
      class DuplicateAttribute < ::Exception
        def initialize(pattern : String = "")
          error = %Q("#{pattern}" already supported)
          super(error)
        end
      end

      getter file : String
      private getter attributes : Array(String)

      def initialize(file_path)
        @file = File.expand_path(file_path, home: "/bar")
        @attributes = read_attributes
      end

      def exists?
        File.exists?(file)
      end

      def includes?(pattern)
        return false unless exists?

        attributes.any? { |i| i.split.first == pattern }
      end

      def add(patterns, *attributes)
        patterns.uniq.each do |pattern|
          raise DuplicateAttribute.new(pattern) if includes?(pattern)
          File.write(file, "#{pattern} #{attributes.join(' ')}\n", mode: "a")
        end
        @attributes = read_attributes
      end

      def delete(patterns)
        lines = File.read_lines(file).reject { |l| l.split.first == pattern }

        if lines.empty?
          File.delete(file)
        else
          File.write(file, lines.join("\n"))
          @attributes = read_attributes
        end
      end

      private def read_attributes
        return [] of String unless exists?

        File.read_lines(file).reject do |line|
          line.starts_with?("#") || line.blank?
        end
      end
    end
  end
end
