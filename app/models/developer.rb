class Developer < User
  validates :name, presence: true
  validates :name, uniqueness: true
  
  before_destroy :ensure_not_referenced_by_any_page_content

  private
	def ensure_not_referenced_by_any_page_content
	  if page_contents.empty?
	  	return true
	  else
	  	errors.add(:base, 'User still has page_contents')
	  	return false
	  end
	end
end
