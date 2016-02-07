class Developer < User
	validates :name, presence: true
	validates :name, uniqueness: true
end
