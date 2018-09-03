class LogsController < ApplicationController
  before_action :load_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: LogDatatable.new(params, view_context: view_context) }
    end
  end

  private

  def load_resource
    return if collection?
    @log = Log.find(params[:id]) if params[:id].present?
  end
end
