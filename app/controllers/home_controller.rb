# frozen_string_literal: true

class HomeController < ApplicationController
  def redirect_shortened
    id = Link.find_by_shortened(Link.prepare_url(params[:path])).id
    params[:link] = { id: id }
    redirect_to api_v1_link_url(id)
  end

  def landing; end
  def favicon; end

  def service_worker; end
end
