class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true

  validates :title, uniqueness: { scope: :user_id,
    message: "you already have an exact same post" }

end
