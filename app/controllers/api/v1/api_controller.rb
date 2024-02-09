module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::ActiveRecordError, with: :return_server_error
      rescue_from ActiveRecord::RecordInvalid, with: :return_bad_request_error
      rescue_from ActionController::ParameterMissing, with: :return_bad_request_error
      rescue_from ActiveRecord::RecordNotFound, with: :return_not_found_error
      rescue_from Faraday::ConnectionFailed, with: :return_service_unavailable_error

      private

      def return_server_error
        render status: :internal_server_error, json: { error: I18n.t(:server_error) }
      end

      def return_bad_request_error
        render status: :bad_request, json: { error: I18n.t(:bad_request_error) }
      end

      def return_not_found_error
        render status: :not_found, json: { error: I18n.t(:not_found_error) }
      end

      def return_service_unavailable_error
        render status: :service_unavailable, json: { error: I18n.t(:service_unavailable_error) }
      end
    end
  end
end
