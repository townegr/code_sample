class Admin::MenusController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def index
    @menus = Menu.includes(:recipes).ordered.page(params[:page]).per(10)
    @recipes = Recipe.ordered
  end

  def show
    @menu = Menu.find(params[:id])

    @recipes = @menu.recipes
  end

  def new
    @last_menu = Menu.all.order(end_at: :desc).limit(1).first

    if @last_menu.present?
      @last_week = @last_menu.start_at

      @start_at = Chronic.parse("next #{Menu::START_DAY} #{Menu::START_TIME}", now: @last_week)
      @end_at = @start_at.to_datetime + 1.week - 1.second
    else
      @start_at = Chronic.parse("last #{Menu::START_DAY} #{Menu::START_TIME}")
      @end_at = @start_at.to_datetime + 1.week - 1.second
    end

    @recipes = Recipe.ordered
    @menu = Menu.new
    Menu::MAX_RECIPES.times { @menu.menu_items.build }
  end

  def create
    @menu = Menu.new(menu_params)
    handle_recipe_priority

    respond_to do |format|
      if @menu.save
        format.html { redirect_to admin_menus_url, notice: "Menu created" }
        format.json { render json: @menu, status: :created, location: @menu }
      else
        format.html { render action: "new" }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @recipes = Recipe.ordered
    @menu = Menu.find(params[:id])
    @menu.menu_items.includes(:recipe).build unless @menu.menu_items.includes(:recipe).present?
  end

  def update
    @menu = Menu.find(params[:id])
    handle_recipe_priority

    respond_to do |format|
      if @menu.update_attributes(menu_params)
        format.html { redirect_to admin_menus_url, notice: "Menu updated" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to admin_menus_url, notice: "Menu deleted" }
    end
  end

  private

  def handle_recipe_priority
    menu_items = params[:menu][:menu_items_attributes]
    if menu_items.present?
      menu_items.keys.each do |menu_item|
        priority = params[:menu][:menu_items_attributes][menu_item][:priority]
      end
    end
  end

  def menu_params
    params.require(:menu).permit(:start_at, :end_at, :status, {recipe_ids: []},
      menu_items_attributes: [:recipe_id, :id, :priority])
  end
end
