class PageContent < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  validates :page_name, uniqueness: { scope: :user_id,
    message: "page name is occupied under your name" }
end
