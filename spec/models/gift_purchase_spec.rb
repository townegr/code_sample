# == Schema Information
#
# Table name: gift_purchases
#
#  id              :integer          not null, primary key
#  gift_id         :integer
#  purchaser_email :string(255)
#  purchaser_name  :string(255)
#  gift_message    :text
#  send_at         :datetime
#  recipient_email :string(255)
#  recipient_name  :string(255)
#  value           :decimal(5, 2)    not null
#  token           :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  stripe_token    :string(255)
#

require 'spec_helper'

describe GiftPurchase do
  it { should have_one(:gift_redemption) }
  it { should belong_to(:gift) }

  describe '#charge_card' do
    before { StripeMock.start }
    after { StripeMock.stop }

    it "charges customer's debit/credit card via Stripe" do
      gift_purchase = FactoryGirl.create(:gift_purchase)

      expect(gift_purchase.status).to eq("Pending charge")

      successful_purchase = gift_purchase.charge_card

      expect(successful_purchase).not_to raise_error
      expect(gift_purchase.status).to eq("Purchased")
    end

    it "returns an error message via Stripe if debit/credit card is declined" do
      gift_purchase = FactoryGirl.create(:gift_purchase)
      StripeMock.prepare_card_error(:card_declined, :new_charge)
      failed_purchase = gift_purchase.charge_card

      expect(gift_purchase.status).to eq("Credit card error")
    end
  end
end
