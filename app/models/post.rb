class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy

  has_and_belongs_to_many :tags

  validates :title, :body, presence: true

  validates :title, uniqueness: { scope: :user_id,
    message: "you already have an exact same post" }

end
