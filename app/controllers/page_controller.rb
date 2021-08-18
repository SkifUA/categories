class PageController < ApplicationController

  def index
    render html: ActionController::Base.render(template: "page/index.html.erb")
  end
end