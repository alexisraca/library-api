class AuthenticateUser
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  attr_accessor :email, :password
  attr_reader :current_user, :authentication_token

  def call
    @authentication_token = authenticate ? ::JsonWebToken.encode(user_id: current_user.id) : nil
  end

  def success?
    @authentication_token.present?
  end

  private

  def authenticate
    @current_user = User.find_by_email(email)
    return @current_user if @current_user && @current_user.authenticate(password)

    errors.add :user_authentication, 'Invalid e-mail or password'
    nil
  end
end
