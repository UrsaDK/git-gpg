module GitGPG
  module Git
    class Attributes
      getter file : String
      private getter attributes : Array(String)

      def initialize(file_path)
        @file = File.expand_path(file_path, home: "/bar")
        @attributes = read_attributes
      end

      def includes?(pattern)
        content.any? { |i| i.split.first == pattern }
      end

      def add(pattern, *attributes)
        File.write(file, "#{pattern} #{attributes.join(' ')}", mode: "a")
        @attributes = read_attributes
      end

      def delete(pattern)
        lines = File.read_lines(file).reject { |l| line.starts_with?(pattern) }
        File.write(file, lines.join("\n"))
        @attributes = read_attributes
      end

      private def read_attributes
        File.read_lines(file).reject do |line|
          line.starts_with?("#") || line.blank?
        end
      end
    end
  end
end
