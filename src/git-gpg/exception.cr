module GitGPG
  class Exception < ::Exception
    getter error : String?
    getter description : String?

    def initialize(@error = "", @description = ""); end

    def message
      if GitGPG.quiet? || description.empty?
        "Error: #{error}"
      else
        "Error: #{error}\n\n#{description}"
      end
    end
  end
end
