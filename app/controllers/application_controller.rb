class ApplicationController < ActionController::Base

  def redirect_shortned
    id = Link.find_by_shortned(Link.prepare_url(params[:path])).id
    params[:link] = { id: id }
    redirect_to link_path(id, params[:link].to_enum.to_h)
  end
end
