class UsersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def show
    @user = current_user
    @current_order = current_user.current_order

    @orders = @user.orders.where(status: 'Delivered').includes(:recipes)
    @orders = @orders.reject { |order| order == @current_order } if @orders.present? && @current_order.present?

    @section = params[:section] || "overview"
  end

  def edit
    @user = current_user
    @section = params[:section] || "overview"
  end

  def update
    @user = current_user
    @section = params[:section] || "overview"

    respond_to do |format|
      if @user.update_attributes(user_params)
        @user.handle_stripe_token if params[:user][:stripe_token].present?

        format.html { redirect_to user_path(current_user), notice: 'Updated!' }
      else
        format.html { redirect_to user_path(current_user, error: :y) + "##{@section}" }
        # format.html { render action: "show", section: @section }
      end
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :image, :remove_image, :first_name, :last_name, :phone, :address, :address2, :city, :state, :zip, :country, :stripe_token, :stripe_cc_last_four, :stripe_cc_type, :stripe_cc_exp_month, :stripe_cc_exp_year)
  end
end
