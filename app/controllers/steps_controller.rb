class StepsController < ApplicationController
  def new
    respond_to &:turbo_stream
  end

  def destroy
    @step = Recipe.find(params[:id])
    @step.destroy

  rescue ActiveRecord::RecordNotFound
    @step = Step.new(id: params[:id])
  ensure
    respond_to do |format|
      format.turbo_stream
    end
  end
end
