class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def collection?
    %w(index).include?(action_name)
  end
end
