class HomeController < ApplicationController
  def index
    p Rails.configuration.x.thing
  end
end
