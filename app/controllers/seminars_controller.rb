class SeminarsController < ApplicationController
  def index
    @seminars = Seminar.all
  end
end
