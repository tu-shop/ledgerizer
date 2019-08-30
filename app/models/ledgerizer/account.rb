module Ledgerizer
  class Account < ApplicationRecord
    extend Enumerize

    belongs_to :tenant, polymorphic: true
    has_many :lines, dependent: :destroy

    enumerize :account_type,
      in: Ledgerizer::Definition::Account::TYPES,
      predicates: { prefix: true }

    validates :name, :currency, :account_type, presence: true
    validates :currency, currency: true
  end
end

# == Schema Information
#
# Table name: ledgerizer_accounts
#
#  id           :integer          not null, primary key
#  tenant_type  :string
#  tenant_id    :integer
#  name         :string
#  currency     :string
#  account_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_ledgerizer_accounts_on_tenant_type_and_tenant_id  (tenant_type,tenant_id)
#
