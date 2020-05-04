module Currency
  module String
    def to_number
      return self.gsub(/^R\$/, '').gsub('.', '').gsub(',', '.').to_f if self.is_real?
    end

    def is_real?
      self =~ /^(R\$)?(|-)?[0-9]+((\.|,)[0-9]+)/ ? true : false
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
