class HomeController < ApplicationController
  def redirect_shortned
    id = Link.find_by_shortned(Link.prepare_url(params[:path])).id
    params[:link] = { id: id }
    redirect_to api_v1_link(id, params[:link].to_enum.to_h)
  end

  def landing
    redirect_to api_v1_links_url
  end
end
