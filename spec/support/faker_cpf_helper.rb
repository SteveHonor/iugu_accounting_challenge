module Faker
  class CPF
    class << self
      def numbers
        numbers = generate
        "%s.%s.%s-%s" % [
          numbers[0..2],
          numbers[3..5],
          numbers[6..8],
          numbers[9..10]
        ]
      end

      private

      def generate
        @handler = calculate_first_digit

        cpf_root << first_validator

        @handler = calculate_second_digit

        @handler += first_validator * 2

        (cpf_root << second_validator).join
      end

      def cpf_root
        Array.new(9) { rand(10) }
      end

      def calculate_first_digit
        (0..8).inject(0) do |handler, i|
          handler + cpf_root[i] * (10 - i)
        end
      end

      def calculate_second_digit
        (0..8).inject(0) do |handler, i|
          handler + cpf_root[i] * (11 - i)
        end
      end

      def first_validator
        first_validator = @handler % 11
        first_validator = first_validator < 2 ? 0 : 11 - first_validator
      end

      def second_validator
        second_validator = @handler % 11
        second_validator = second_validator < 2 ? 0 : 11 - second_validator
      end
    end
  end
end
