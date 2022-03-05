class SeminarsController < ApplicationController
  def index
    @seminars = Seminar.all
  end
  def new
    @seminar = Seminar.new
    render plain: render_to_string(partial: 'form_new', layout: false, locals: { seminar: @seminar })
  end
  def create
    @seminar = Seminar.new(params_seminar)
    if @seminar.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      respond_to do |format|
        format.js {render partial: "error" }
      end
    end
  end

  def params_seminar
      params.require(:seminar).permit(:title, :starts_at, :ends_at)
  end

end
