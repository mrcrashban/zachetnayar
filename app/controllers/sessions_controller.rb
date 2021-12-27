# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :no_authentication, only: %i[new create]
  def new; end

  def create
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "#{t('flash.success_logged_in')} #{user.nickname}!"
      redirect_to root_path
    else
      flash[:warning] = t('flash.incorrectly_data')
      redirect_to new_session_path
    end
  end

  def destroy
    sign_out
    flash[:success] = t('flash.success_logged_out')
    redirect_to root_path, method: :get
  end
end