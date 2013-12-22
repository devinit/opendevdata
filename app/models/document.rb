class Document
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Taggable

  before_save :set_time
  field :name, type: String
  slug :name
  field :description, type: String
  field :uploaded_on, type: Time

  validates :name, :description, :user_id, presence: true

  mount_uploader :attachment, DocumentUploader

  belongs_to :user

  private
  def set_time
    self.uploaded_on = Time.now if uploaded_on.nil?
  end
end
