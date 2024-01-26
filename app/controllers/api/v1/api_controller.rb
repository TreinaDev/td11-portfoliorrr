module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_server_error

      private

      def return_server_error
        error_msg = 'Houve um erro interno no servidor ao processar sua solicitação.'
        render status: :internal_server_error, json: { error: error_msg }
      end
    end
  end
end
