class CopyController < ApplicationController
  def index
    render json: @@copy_data
  end

  def show
    render json: json_mapping
  end

  private

  def json_mapping
    message = @@copy_data[copy_params[:key]].to_s

    copy_params.reject{ |k, _| k == 'key' }.each do |param, value|
      if (message.include? '{created_at, datetime}') && (param == 'created_at')
        created_at = Time.zone.at(value.to_i)
        message.gsub! '{created_at, datetime}', created_at.strftime('%a %b %d %r')
      else
        message.gsub! "{#{param}}", value
      end
    end

    { value: message }
  end

  def copy_params
    params.permit(:key, :name, :app, :created_at)
  end
end
