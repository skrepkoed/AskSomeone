class Api::V1::ProfilesController<Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def index
    render json: User.without_user(current_resource_owner)
  end
end