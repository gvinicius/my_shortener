class LinksController < ApplicationController
  before_action :set_link, only: %i[show]

  # GET /links or /links.json
  def index
    @links = Link.all
  end

  # GET /links/1 or /links/1.json
  def show
    @link.increment_access_count

    redirect_to(@link.original)
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.where(id: params[:id]).first || Link.find_by_shortned(Link.prepare_url(params[:path]))
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:original)
  end
end
