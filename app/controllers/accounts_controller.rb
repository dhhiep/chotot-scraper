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
    @account.update(inserted_at: Time.current)
  end

  def mark_wse_status
    case params[:status]
    when 'unknown'
      @account.wse_unknown!
    when 'valid'
      @account.wse_valid!
    when 'duplicate'
      @account.wse_duplicate!
    when 'invalid'
      @account.wse_invalid!
    end
  end

  def fetch_zalo_info
    @account.fetch_zalo_info!
  end

  def hide
    @account.hide!
  end

  def toggle_favorite
    @account.toggle_favorite!
  end

  private

  def load_resource
    return if collection?
    @account = Account.find(params[:id]) if params[:id].present?
  end
end
