class Api::V1::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user!
  def facebook 
    p request.env["omniauth.auth"]
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      # sign_in @user 
      # render :json => @user
      sign_in_and_redirect @user, :store => false
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    end
  end
end
