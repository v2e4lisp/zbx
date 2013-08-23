module ZBX
  module CLI
    module Helper
      extend self

      def browse link
        case RbConfig::CONFIG['host_os']
        when /mswin|mingw|cygwin/
          system "start #{link}"
        when /darwin/
          system "open #{link}"
        when /linux|bsd/
          system "xdg-open #{link}"
        end

      end
    end
  end
end
