class Edge < ActiveRecord::Base
  belongs_to :tag
  validates :target_id, :tag_id, inclusion: { in: Tag.ids, message: " is not found"}
  validates :edge_type, inclusion: { in: ["parent_of", "child_of"], message: "edge type is invalid"}
  validates :target_id, uniqueness: { scope: [:tag_id, :edge_type]}
  def target_tag
  	tag = Tag.find(self.target_id)
  end
end
