module Ledgerizer
  module Formatters
    def infer_active_record_class!(model_name)
      model_name.to_s.classify.constantize
    rescue NameError
      raise_formatter_error("name must be an ActiveRecord model name")
    end

    def format_currency!(currency)
      formatted_currency = currency.to_s.downcase.to_sym
      return :usd if formatted_currency.blank?
      return formatted_currency if Money::Currency.table.key?(formatted_currency)

      raise_formatter_error("invalid currency '#{currency}' given")
    end

    def raise_formatter_error(msg)
      raise Ledgerizer::Error.new(msg)
    end
  end
end
