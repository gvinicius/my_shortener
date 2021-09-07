class Api::V1::LinksController < ApiController
  before_action :set_link, only: %i[show]

  # GET /links or /links.json
  def index
    @links = Link.ordered_by_date
  end

  # GET /links/1 or /links/1.json
  def show
    @link.increment_access_count

    redirect_to(@link.original)
  end

  # POST /links
  def create
    link_params.delete(:id)
    current_user_pair = { user_id: current_user.try(:id) }
    @link = Link.new(link_params.merge(current_user_pair))

    if @link.save
      render :show, status: :created
    else
      render json: @link.errors, status: :unprocessable_entity
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:original, :id)
  end
end
