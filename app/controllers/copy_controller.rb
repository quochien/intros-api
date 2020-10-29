class CopyController < ApplicationController
  def index
    render json: COPY_DATA
  end
end
