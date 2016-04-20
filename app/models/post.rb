class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy

  has_and_belongs_to_many :tags, :join_table => :Posts_Tags

  validates :title, :body, presence: true

  validates :title, uniqueness: { scope: :user_id,
    message: "you already have an exact same post" }

	def is_reference
		self.ref_link != nil
	end
end
