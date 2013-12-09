class Document
  include Mongoid::Document
  before_save :set_time
  field :name, type: String
  field :description, type: String
  field :uploaded_on, type: Time

  validates :name, :description, :user_id, presence: true

  mount_uploader :upload, DocumentUploader

  belongs_to :user

  private
  def set_time
    self.uploaded_on = Time.now if uploaded_on.nil?
  end
end
