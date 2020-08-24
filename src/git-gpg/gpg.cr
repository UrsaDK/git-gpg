module GitGPG
  module GPG
    extend self

    def encrypt(file, content, recipients)
      puts "--> GPG.encrypt:"
      puts "  FILE --> #{file}"
      puts "  CONTENT --> #{content}"
      puts "  RECIPIENTS --> #{recipients}"
      "GPG.encrypt(#{file}, ...)"
    end

    def decrypt(file, content)
      puts "--> GPG.decrypt:"
      puts "  FILE --> #{file}"
      puts "  CONTENT --> #{content}"
      "GPG.decrypt(#{file}, ...)"
    end
  end
end
