# Just for test.
class HomeController < ApplicationController
  def index
  end

  def help
  end

  def about
    respond_to do |format|
      format.html  # about.html.erb
      format.json { render json:
        { object_id: RailsAmp.config.object_id, format: RailsAmp.config.format }
      }
    end
  end
end
