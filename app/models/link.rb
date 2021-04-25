class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format:{ with: URI.regexp }

  def gist?
    url.match? /^https:\/\/gist.github.com\/\w+\/\w{32}$/
  end
end
