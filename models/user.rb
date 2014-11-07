class User < ActiveRecord::Base
  ROLES = ["member", "admin"]

  has_many :orders
  has_many :recipes, -> { uniq }, through: :orders
  has_many :gift_redemptions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :image, ImageUploader

  before_update :clean_shipping_address
  before_create :set_role, :generate_account_number

  scope :ordered, -> { order(created_at: :desc) }

  def current_order
    this_week = Menu.this_week
    if this_week.present?
      orders = this_week.orders.where(user_id: id)
      orders.present? ? orders.first : Order.none
    else
      Order.none
    end
  end

  def clean_shipping_address
    if shipping_address_changed? && shipping_address_complete?
      fedex = Fedex::Shipment.new(Rails.application.secrets.fedex)

      fedex_check = fedex.validate_address(address: shipping_address)

      if !fedex_check.confirmed
        self.address = fedex_check.street_lines
        self.city = fedex_check.city
        self.state = fedex_check.state
        self.zip = fedex_check.postal_code

        errors.add(:user, "must have a valid shipping address. Please verify your address and try again.")

        return false
      else
        self.address = fedex_check.street_lines
        self.city = fedex_check.city
        self.state = fedex_check.state
        self.zip = fedex_check.postal_code
        self.is_residential = fedex_check.residential

        return true
      end
    end
  end

  def shipping_address
    {
      name: full_name,
      address: [address, address2],
      city: city,
      state: state,
      postal_code: zip,
      country_code: country,
      phone_number: "617-299-0246",
      residential: is_residential
    }
  end

  def shipping_address_changed?
    self.address_changed? || self.address2_changed? || self.city_changed? || self.state_changed? || self.zip_changed? || self.country_changed?
  end

  def shipping_address_complete?
    (first_name.present? && last_name.present? && address.present? && city.present? && state.present? && zip.present? && country.present?)
  end

  def full_address
    address2.present? ? "#{address}, #{address2}" : "#{address}"
  end

  def location
    (city.present? && state.present?) ? "#{city}, #{state}" : ""
  end

  def full_name
    (first_name.present? && last_name.present?) ? "#{first_name} #{last_name}" : ""
  end

  def display_name
    (first_name.present? && last_name.present?) ? "#{first_name} #{last_name}" : email
  end

  def password_required?
    new_record? ? super : false
  end

  def display_credit
    if credit > 0.0
      credit / Order::DEFAULT_PRICE
    end
  end

  def handle_stripe_token
    if self.stripe_customer_id.present?
      begin
        customer = Stripe::Customer.retrieve(self.stripe_customer_id)
        customer.card = self.stripe_token
        customer.save
      rescue Stripe::StripeError => e
        puts "STRIPE UPDATE CARD ERROR: #{e}"
      end
    else
      begin
        customer = Stripe::Customer.create(
          :card => self.stripe_token,
          :email => self.email,
          :description => "TPC customer: #{self.id}"
        )
        self.stripe_customer_id = customer.id
        self.save
      rescue Stripe::StripeError => e
        puts "STRIPE NEW CARD ERROR: #{e}"
      end
    end
  end

  def adjust_credit(reduce_by_amount)
    if credit > 0.00
      remainder = credit - reduce_by_amount
      if remainder > 0.00
        self.credit = remainder
        self.save!

        return reduce_by_amount
      else
        start_credit = self.credit
        self.credit = 0.00
        self.save!

        return start_credit
      end
    else
      return 0.00
    end
  end

  private

  def generate_account_number
    account_number = ""
    loop do
      account_number = Random.new.bytes(8).bytes.join[0,8]
      break account_number unless User.where(account_number: account_number).first
    end
    self.account_number = account_number.to_i
  end

  def set_role
    self.role = "member" if self.role.blank?
  end
end
