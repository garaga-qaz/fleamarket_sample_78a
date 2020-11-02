class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def production?
    Rails.env.production?
  end

  protected

  def configure_permitted_parameters
    added_attrs = [ :nickname, :email, :password, :password_confirmation, :first_name, :family_name, :first_furigana, :family_furigana, :birthday, :recipient_family_name, :recipient_first_name, :recipient_family_furigana, :recipient_first_furigana, :zip_cord, :prefecture, :city, :address, :mansion, :tel ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end


end