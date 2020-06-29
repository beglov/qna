class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    current_user.subscriptions.find_or_create_by(question_id: params[:question_id])
  end

  def destroy
    current_user.subscriptions.find_by(question_id: params[:id]).try(:destroy)
  end
end
