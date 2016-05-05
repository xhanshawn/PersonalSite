class Edge < ActiveRecord::Base
	
  belongs_to :tag
  validates :target_id, :tag_id, inclusion: { in: Tag.ids, message: " is not found"}

  def self.valid_edge_types
  	["parent_of", "solution_to"]
  end

  validates :edge_type, inclusion: { in: self.valid_edge_types, message: "edge type is invalid"}

  validates :target_id, uniqueness: { scope: [:tag_id, :edge_type], message: "duplicate"}
  
  def target_tag
  	tag = Tag.find(self.target_id)
  end

  
end
