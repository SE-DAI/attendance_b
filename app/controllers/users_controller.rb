class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, :admin_or_correct_user, only: :show
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    if logged_in?
      unless current_user.admin?
        flash[:warning] = "すでにアカウントは作成済みです。"
        redirect_to current_user
      else
        @user = User.new
      end
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def edit
    
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
    else
      flash[:danger] = "更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def search
    if params[:keyword].present?
      @users = User.paginate(page: params[:page]).search(params[:keyword])
      @keyword = params[:keyword]
      render :search
    else
      flash[:info]= "検索候補を入力してください。"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit %i( name email department password password_confirmation )
  end

  def basic_info_params
    params.require(:user).permit %i( basic_time work_time )
  end

end
