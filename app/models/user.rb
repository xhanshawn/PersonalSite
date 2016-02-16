class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :type, inclusion: { in: %w(Developer), 
    message: "%{value} is not a valid type. If you have the developer code, please enter \"Developer\" in type field. If not, just leave it blank" },  allow_blank: true
  has_secure_password


  has_many :page_contents, dependent: :destroy
  
  # validates :password, length: { minimum: 8 }, allow_nil: true
  


  attr_accessor :developer_code

  def is_dev?
  	self.type == 'Developer'
  end

  class Developer < User; end
end
