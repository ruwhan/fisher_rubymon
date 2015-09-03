class Api::V1::SessionsController < Api::V1::BaseApiController
  def create
    user_email = params[:session][:email]
    user_password = params[:session][:password]
    user = user_email.present? && User.find_by(email: user_email)

    if !user 
      render :json => { errors: "User is not exist" }, status: 422
    elsif user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render :json => user, status: 200, location: [:api, user]
    else
      render :json => { errors: "Invalid email or password" }, status: 422
    end
  end

  def create_from_facebook
    user = User.from_facebook(facebook_params)

    if user.persisted?
      sign_in user, store: false
      render :json => user
    else
      render :json => { errors: user.errors }
    end
  end

private
  def auth_hash
    request.env['omniauth.auth']
  end

  def facebook_params
    params.require(:facebook).permit(:uid, :email, :first_name, :middle_name, :last_name, :name, :gender, :link, :locale, :timezone, :updated_time, :verified);
  end
end
