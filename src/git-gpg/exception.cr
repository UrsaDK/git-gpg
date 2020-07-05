module GitGPG
  class Exception < ::Exception
    getter error : String?
    getter description : String?

    def initialize(@error = "", @description = ""); end

    def message
      text = GitGPG.quiet? ? error : "#{error}\n\n#{description}"
      "Error: #{text}"
    end
  end
end
