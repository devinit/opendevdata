class Document
  include Mongoid::Document
  before_save :set_time
  field :name, type: String
  field :description, type: String
  field :uploaded_on, type: Time

  validates :name, :description, presence: true

  mount_uploader :upload, DocumentUploader

  private
  def set_time
    self.uploaded_on = Time.now if uploaded_on.nil?
  end
end
