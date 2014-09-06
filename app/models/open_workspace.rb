class OpenWorkspace
  include Mongoid::Document
  include Mongoid::Slug

  field :organization_name, type: String
  slug :organization_name
  field :location, type: String
  field :description, type: String
  field :approved, type: Boolean, default: false

  has_many :memberships, dependent: :destroy
  has_many :datasets
  has_many :documents

  validates :organization_name, :location, :description, presence: true

  validates :description, length: { maximum: 250 }

  # Avoid duplicate organization names
  # validates :organization_name, uniqueness: { conditions: -> {where(deleted_at: nil)}}
  validates :organization_name, uniqueness: true

  def users
    # get users that are members of this workspace
    User.in id: memberships.map(&:user_id)
  end

  def apply_to_join(user)
    self.memberships.create(user: user)
  end

  def has_change_access? user
    self.memberships.where(user: user, admin: true).exists? or user.is_admin?
  end
end
