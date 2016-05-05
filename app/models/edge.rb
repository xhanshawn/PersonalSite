class Edge < ActiveRecord::Base
	
  belongs_to :tag
  # validates :target_id, :tag_id, inclusion: { in: Tag.ids, message: " is not found"}
  validate :validate_tags

  def self.valid_edge_types
  	["parent_of", "solution_to"]
  end

  validates :edge_type, inclusion: { in: self.valid_edge_types, message: "edge type is invalid"}

  validates :target_id, uniqueness: { scope: [:tag_id, :edge_type], message: "duplicate"}
  
  def target_tag
  	tag = Tag.find(self.target_id)
  end

  private 

    def validate_tags
      errors.add(:tag_id, " is invalid") unless Tag.exists?(self.tag_id)
      errors.add(:target_id, " is invalid") unless Tag.exists?(self.target_id)
    end
end
