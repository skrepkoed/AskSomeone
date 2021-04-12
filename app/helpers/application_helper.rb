module ApplicationHelper

  def resource_authored_by_user?(resource)
    resource.author == current_user
  end
end
