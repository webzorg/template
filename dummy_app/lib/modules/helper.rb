module Helper
  extend ActionView::Helpers::NumberHelper

  class << self
    def humanize_boolean(boolean)
      case boolean
      when true  then I18n.t("misc.yes_")
      when false then I18n.t("misc.no_")
      end
    end

    def humanize_date(datetime)
      return datetime unless [Date, DateTime, Time].include?(datetime.class)

      datetime.strftime("%-d.%-m.%Y")
    end

    def humanize_price(amount)
      number_to_currency(amount.to_d / 100, unit: "₾")
    end
  end
end
