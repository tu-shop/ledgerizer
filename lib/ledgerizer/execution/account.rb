module Ledgerizer
  module Execution
    class Account
      def initialize(
        tenant_id:,
        tenant_type:,
        accountable_id:,
        accountable_type:,
        account_type:,
        account_name:,
        currency:
      )
        @tenant_id = tenant_id
        @tenant_type = tenant_type
        @accountable_id = accountable_id
        @accountable_type = accountable_type
        @account_type = account_type
        @account_name = account_name
        @currency = currency
      end

      def ==(other)
        to_array == other.to_array
      end

      def eql?(other)
        self == other
      end

      def identifier
        to_array.join('::')
      end

      def to_array
        [
          tenant_type,
          tenant_id,
          accountable_type,
          accountable_id,
          account_type,
          account_name,
          currency
        ].map(&:to_s)
      end

      def to_hash
        {
          tenant_id: tenant_id,
          tenant_type: tenant_type,
          accountable_id: accountable_id,
          accountable_type: accountable_type,
          account_type: account_type,
          name: account_name,
          currency: currency
        }
      end

      def <=>(other)
        to_array <=> other.to_array
      end

      def balance
        params = to_hash.dup
        params[:account_name] = params.delete(:name)
        balance_currency = params.delete(:currency)
        Ledgerizer::Line.where(params).amounts_sum(balance_currency)
      end

      private

      attr_reader :account_type, :account_name, :currency
      attr_reader :accountable_id, :accountable_type
      attr_reader :tenant_id, :tenant_type
    end
  end
end
