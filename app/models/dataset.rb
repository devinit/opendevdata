class Dataset
  include Mongoid::Document
  include Mongoid::Slug

  before_save :set_time

  field :name, type: String
  slug :name
  field :description, type: String
  field :chart_type, type: String
  field :data_extract, type: Hash

  # chart labels
  field :x_label, type: String
  field :y_label, type: String
  field :title, type: String
  field :sub_title, type: String
  field :data_units, type: String  # suffix for tooltip
  field :created_at, type: Time
  field :edited_at, type: Time

  mount_uploader :attachment, DatasetFileUploader

  belongs_to :organization
  belongs_to :user

  validates :name, :description, :chart_type, :sub_title, :title, presence: true

  embeds_many :comments

  protected
    def set_time
      if created_at.nil?
        self.created_at = Time.now
      else
        self.edited_at = Time.now  # update the edited time
      end
    end
end
