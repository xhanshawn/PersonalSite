class Post < ActiveRecord::Base
  belongs_to :user
  validates :title, :body, presence: true

  validates :title, uniqueness: { scope: :user_id,
    message: "you already have an exact same post" }

end
