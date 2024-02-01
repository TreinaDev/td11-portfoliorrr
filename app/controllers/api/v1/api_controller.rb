module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_server_error
      rescue_from ActiveRecord::RecordInvalid, with: :return_bad_request_error
      rescue_from ActionController::ParameterMissing, with: :return_bad_request_error
      rescue_from ActiveRecord::RecordNotFound, with: :return_not_found_error

      private

      def return_server_error
        error_msg = 'Houve um erro interno no servidor ao processar sua solicitação.'
        render status: :internal_server_error, json: { error: error_msg }
      end

      def return_bad_request_error
        error_msg = 'Houve um erro ao processar sua solicitação.'
        render status: :bad_request, json: { error: error_msg }
      end

      def return_not_found_error
        error_msg = 'Não encontrado'
        render status: :not_found, json: { error: error_msg }
      end
    end
  end
end
