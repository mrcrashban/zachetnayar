# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authentication, only: %i[new create update edit destroy]
  before_action :before_recieve, only: %i[show destroy edit update]
  before_action :authorization_user?, only: %i[update edit destroy]

  def index
    @posts = Post.order(created_at: :desc).page params[:page]
  end

  def our; end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build recieve_params
    if @post.save
      flash[:success] = t('flash.create_story')
      redirect_to posts_path
    else
      render :new
    end
  end

  def update
    if @post.update recieve_params
      redirect_to users_path
      flash[:success] = t('flash.update_story')
    else
      render :new
    end
  end

  def edit; end

  def show; end

  def destroy
    @post.destroy
    flash[:success] = t('flash.delete_story')
    redirect_to users_path
  end

  private

  def recieve_params
    params.require(:post).permit(:title, :body)
  end

  def before_recieve
    @post = Post.find params[:id]
  end

  def authorization_user?
    return if current_user == @post.user

    flash[:warning] = t('flash.not_author')
    redirect_to root_path
  end
end