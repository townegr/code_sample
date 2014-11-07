class Menu < ActiveRecord::Base
  STATUSES = ["Active", "Locked"]
  START_DAY = 'tuesday'
  START_TIME = '18:00'
  MAX_RECIPES = 4
  NUMBER_OF_DAYS_FOR_DELIVERY = 2

  has_many :menu_items
  has_many :recipes, through: :menu_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  validate :maximum_recipes_per_menu

  accepts_nested_attributes_for :menu_items, reject_if: :all_blank, allow_destroy: true

  validates :start_at, presence: true
  validates :end_at, presence: true

  before_create :set_status

  scope :ordered, -> { order(start_at: :desc) }

  def delivery_date
    end_at.end_of_day + 1.minute + NUMBER_OF_DAYS_FOR_DELIVERY.days
  end

  def maximum_recipes_per_menu
    errors.add(:recipes, "Cannot exceed #{MAX_RECIPES} recipes") if recipes.size > MAX_RECIPES
  end

  def self.this_week
    menu = Menu.where('? BETWEEN start_at and end_at', Time.now)
    menu.present? ? menu.first : Menu.new
  end

  def self.next_week
    menu = Menu.where('? BETWEEN start_at and end_at', Chronic.parse("next #{Menu::START_DAY} #{Menu::START_TIME}"))
    menu.present? ? menu.first : nil
  end

  def self.weeks_ago(number)
    begin
      start_date = Menu.this_week.start_at - number.week
      prev_menu = Menu.where(start_at: start_date)
      prev_menu.present? ? prev_menu.first : Menu.new
    rescue
      Menu.new
    end
  end

  def to_s
    "#{start_at.strftime('%b %d, %Y')} - #{end_at.strftime('%b %d, %Y')}"
  end

  private

  def set_status
    self.status = 'Active' if self.status.blank?
  end

end
