class User < ActiveRecord::Base
  # self.inheritance_column = :fake_column
  validates :name, presence: true, uniqueness: true
  validates :type, inclusion: { in: %w(Developer),
    message: "%{value} is not a valid type" }
  has_secure_password


  def is_dev?
  	self.type == 'Developer'
  end

  class Developer < User; end
end
