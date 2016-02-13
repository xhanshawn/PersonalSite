class PageContent < ActiveRecord::Base
  belongs_to :developer
  validates :developer_id, presence: true

  validates :page_name, uniqueness: { scope: :developer_id,
    message: "page name is occupied under your name" }
end
