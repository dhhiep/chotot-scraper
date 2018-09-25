class PotentialsController < ApplicationController
  before_action :set_potential, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: PotentialDatatable.new(params, view_context: view_context) }
    end
  end

  def new
    @potential = Potential.new
  end

  def create
    @potential = Potential.new(potential_params)

    respond_to do |format|
      if @potential.save
        format.html { redirect_to potentials_path, notice: 'Potential was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @potential.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @potential.update(potential_params)
        format.html { redirect_to potentials_path, notice: 'Potential was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @potential.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @potential.destroy
  end

  private

    def set_potential
      @potential = Potential.find(params[:id])
    end

    def potential_params
      params.require(:potential).permit(:name, :phone, :account_id, :remind_at_field, :owner)
    end
end
