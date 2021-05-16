class SingleAnswerSerializer < ActiveModel::Serializer
  type 'answer'
  attributes :id, :body, :created_at, :updated_at, :links_url, :files_url
  belongs_to :author
  has_many :comments

  def links_url
   object.links.pluck(:url) 
  end

  def files_url
    object.files.map{ |file| Rails.application.routes.url_helpers.rails_blob_path(file,only_path: true) } unless object.files.empty?
  end
end
