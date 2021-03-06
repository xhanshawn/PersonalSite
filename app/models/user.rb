class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  # validates :type, inclusion: { in: "Developer", 
  #   message: "%{value} is not a valid type. If you have the developer code, please enter \"Developer\" in type field. If not, just leave it blank" },  allow_blank: true

  has_secure_password


  has_many :page_contents, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  # validates :password, length: { minimum: 8 }, allow_nil: true
  


  attr_accessor :developer_code

end
