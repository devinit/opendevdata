class Document
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Taggable
  include PublicActivity::Model
  tracked

  before_save :set_time
  field :name, type: String
  slug :name
  field :description, type: String
  field :uploaded_on, type: Time
  field :approved, type: Boolean, default: false

  validates :name, :description, :attachment, :user_id, presence: true

  mount_uploader :attachment, DocumentUploader

  belongs_to :user
  belongs_to :open_workspace
  embeds_many :comments

  def self.search search
    ret = []
    if search
      ret << any_of({name: /#{search}/i}).to_a
      ret << tagged_with(/#{search}/i).to_a  # search tagged documents
      ret
    end
  end

  private
  def set_time
    self.uploaded_on = Time.now if uploaded_on.nil?
  end
end
