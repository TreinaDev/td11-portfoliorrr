class SubscriptionsController < ApplicationController
  def index
    @subscription = current_user.subscription
  end

  def update
    @subscription = Subscription.find params[:id]
    @subscription.active!
    redirect_to subscriptions_path, notice: t('.success')
  end
end
