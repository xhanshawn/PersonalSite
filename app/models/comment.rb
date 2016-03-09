class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post_id, :user_id, :body, presence: true

  validates :body, uniqueness: { scope: :user_id,
    message: "you already have an exact same comment" }
end
