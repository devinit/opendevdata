class Dataset
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Taggable
  include PublicActivity::Model
  tracked
  has_many :feedbacks
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
  field :no_viz, type: Boolean, default: true
  field :approved, type: Boolean, default: false

  field :view_count, type: Integer, default: 0
  field :download_count, type: Integer, default: 0

  mount_uploader :attachment, DatasetFileUploader

  belongs_to :open_workspace
  belongs_to :user
  # embedded_in :organization

  validates :name, :description, :sub_title, presence: true

  embeds_many :comments

  def self.to_csv options = {}
    column_names = self.fields.keys
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |dataset|
        csv << dataset.attributes.values_at(*column_names)
      end
    end
  end

  def self.search search
    ret = []
    if search
      ret << any_of({name: /#{search}/i}).to_a
      ret << tagged_with(/#{search}/i).to_a
    end
    ret
  end

  protected
    def set_time
      if created_at.nil?
        self.created_at = Time.now
      else
        self.edited_at = Time.now  # update the edited time
      end
    end
end
