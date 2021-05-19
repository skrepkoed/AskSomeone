class SingleQuestionSerializer < ActiveModel::Serializer
  type 'question'
  attributes :id, :title, :body, :created_at, :updated_at, :links_url, :files_url
  has_many :comments
  belongs_to :author
  has_many :files

  def links_url
    object.links.pluck(:url)
  end

  def files_url
    unless object.files.empty?
      object.files.map do |file|
        Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      end
    end
  end
end
