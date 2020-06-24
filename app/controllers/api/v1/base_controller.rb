class Api::V1::BaseController < ApplicationController
  include Response
  include ExceptionHandler
  before_action :doorkeeper_authorize!

  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
