module GitGPG
  module Exceptions
    class OptionError < ::Exception
      getter explanation : String

      def initialize(message : String = "", explanation : String = "")
        super("ERROR: #{message}")
        @explanation = explanation
      end
    end
  end
end
