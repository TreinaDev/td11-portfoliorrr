class SettingsController < ApplicationController
  def index
  end

  def deactivate_account
    redirect_to root_path, alert: 'Conta desativada com sucesso'
  end
end
