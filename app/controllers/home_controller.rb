class HomeController < ApplicationController
  def redirect_shortned
    id = Link.find_by_shortned(Link.prepare_url(params[:path])).id
    params[:link] = { id: id }
    redirect_to api_v1_link_url(id)
  end

  def landing
  end
end
