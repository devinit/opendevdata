class Workspace
  include Mongoid::Document
  field :organization_name, type: String
  field :location, type: String
  field :description, type: String

  has_many :memberships, dependent: :destroy
  has_many :datasets

  validates :organization_name, :location, :description, presence: true

  def users
    # get users that are members of this workspace
    User.in id: memberships.map(&:user_id)
  end
end
