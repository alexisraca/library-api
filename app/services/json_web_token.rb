class JsonWebToken
  class << self
    def encode(application_id = nil)
      JWT.encode({ application_id: application_id || ENV["APP_ID"] }, ENV["SECRET_KEY_BASE"])
    end
 
    def decode(token)
      body = JWT.decode(token, ENV["SECRET_KEY_BASE"])[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end