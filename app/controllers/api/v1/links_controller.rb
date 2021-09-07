class Api::V1::LinksController < ApiController
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
    link_params.delete(:id)
    current_user_pair = { user_id: current_user.try(:id) }
    @link = Link.new(link_params.merge(current_user_pair))

    respond_to do |format|
      if @link.save
        format.html { redirect_to api_v1_link_url(@link), notice: 'Link was successfully created.' }
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
    @link = Link.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:original, :id)
  end
end
