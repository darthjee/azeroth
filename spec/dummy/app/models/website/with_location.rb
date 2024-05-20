class Website < ActiveRecord::Base
  module WithLocation
    def location
      "#{protocol}://#{domain}:#{port}"
    end

    def protocol
      website.protocol || '*'
    end

    def domain
      website.domain || '*'
    end

    def port
      website.port || '*'
    end
  end
end
