module Akatus

  module Services

    class Refund < Akatus::Service

      PATH = 'estornar-transacao'
      METHOD = :post

      def self.execute(payment)
        self.new.execute(payment)
      end

      def execute(payment)
        @payment = payment

        data = send_request

        @payment.refunded = true if data['codigo-retorno'] == 0

        @payment
      end

      def to_payload
        {
          'estorno' => {
            'transacao' => @payment.transaction_id,
            'api_key'   => @payment.receiver.api_key,
            'email'     => @payment.receiver.email
          }
        }
      end

    end

  end

end
