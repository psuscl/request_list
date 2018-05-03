require 'securerandom'

module HarvardCommon

  def get_request_number
    SecureRandom.hex(4)
  end

end
