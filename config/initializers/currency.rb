module Currency
  module String
    def to_number
      return self.is_real? ? self.gsub(/^R\$/, '').gsub('.', '').gsub(',', '.').to_f : self.to_f
    end

    def is_real?
      self =~ /^(R\$)?((\d+)|(\d{1,3})(\.\d{3}|)*)(\,\d{2}|)$/ ? true : false
    end
  end

  module Number
    include ActionView::Helpers::NumberHelper

    def to_real
      number_to_currency(
        self,
        unit: "R$",
        separator: ",",
        delimiter: ".",
        precision: 2
      )
    end
  end
end

class BigDecimal; include Currency::Number; end
class Float; include Currency::Number; end
class String; include Currency::String; end
