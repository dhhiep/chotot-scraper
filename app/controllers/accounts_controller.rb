class AccountsController < ApplicationController
  before_action :load_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: AccountDatatable.new(params, view_context: view_context) }
    end
  end

  def mark_review
    @account.status_inserted!
  end

  private

  def load_resource
    return if collection?
    @account = Account.find(params[:id]) if params[:id].present?
  end
end
