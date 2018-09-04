class LogsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: LogDatatable.new(params, view_context: view_context) }
    end
  end

  def show
    @logs = Summary.where(uuid: params[:id]).order(created_at: :desc)
  end
end
