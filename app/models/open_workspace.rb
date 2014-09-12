class OpenWorkspace
  include Mongoid::Document
  include Mongoid::Slug
  include PublicActivity::Model
  tracked

  before_create :generate_blog_tag_id, if: Proc.new { |open_workspace| open_workspace.new_record? }

  field :organization_name, type: String
  slug :organization_name
  field :location, type: String
  field :description, type: String
  field :approved, type: Boolean, default: false
  field :blog_tag_id, type: String

  has_many :memberships, dependent: :destroy
  has_many :datasets
  has_many :documents
  has_many :messages

  validates :organization_name, :location, :description, presence: true

  validates :description, length: { maximum: 250 }

  validates :blog_tag_id, uniqueness: true

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

  def update_blog_tag_id!
    generate_blog_tag_id
    self.save # for safety
  end

  private
    def generate_blog_tag_id
      begin
        blg_tag_id = "#{SecureRandom.hex 2}"
      end while OpenWorkspace.where(blog_tag_id: blg_tag_id).exists?
      self.blog_tag_id = blg_tag_id
    end

end
