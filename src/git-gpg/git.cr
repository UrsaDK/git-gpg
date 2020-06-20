module GitGPG
  module Git
    extend self

    def attribute(file, attribute)
      puts "--> Git.attribute:"
      puts "  FILE --> #{file}"
      puts "  ATTRIBUTE --> #{attribute}"
      "Git.attribute(#{file}, #{attribute})"
    end
  end
end
