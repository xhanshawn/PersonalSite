class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts, :join_table => :Posts_Tags
  has_many :edges
  validates :name, presence: true, uniqueness: true
end
