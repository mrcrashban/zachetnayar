# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :no_authentication, only: %i[new create]
  before_action :authentication, only: %i[edit update index]
  before_action :my_find_user, only: %i[edit update]
  before_action :authorization_user?, only: %i[edit update]

  def index
    @posts = current_user.present? ? current_user.posts.order(created_at: :desc).page(params[:page]) : nil
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new recieve_params_for_new
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "#{t('flash.success_signed_in')} #{@user.nickname}!"
      redirect_to root_path
    else
      render :new
      flash[:warning] = "#{t('flash.not_success_signed_in')} #{@user.nickname}!"
    end
  end

  def update
    if @user.update recieve_params_for_edit
      redirect_to root_path
      flash[:success] = t('flash.success_updated')
    else
      render :new
    end
  end

  def edit; end

  private

  def recieve_params_for_new
    params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
  end

  def recieve_params_for_edit
    params.require(:user).permit(:email, :nickname)
  end

  def my_find_user
    @user = User.find params[:id]
  end

  def authorization_user?
    return if current_user.email == @user.email

    flash[:warning] = t('flash.change_other_user')
    redirect_to root_path
  end
end