class JoinedUpDataset
  require 'smarter_csv'
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Taggable
  include Mongoid::Timestamps
  include PublicActivity::Model
  tracked
  # before_save :set_time

  field :created_at, type: Time
  field :edited_at, type: Time

  field :name, type: String
  field :source_of_data, type: String

  # TODO -> scope out joined up data
  field :time_value, type: String
  # field :time_format, type: String
  field :value, type: BigDecimal  # convert integers to decimals too ;-)

  field :data_extract, type: Hash
  field :approved, type: Boolean, default: false

  # this is flagged off after sidekiq has done its magic
  field :pending, type: Boolean, default: true

  has_one :time_format
  has_one :space_value # related to space_value

  belongs_to :open_workspace
  belongs_to :user  # who uploaded
  # belongs_to :data_serie

  # Basic Validations
  field :status, type: String
  field :data_choice_made, type: Boolean # default is nil! We don't want whiny nils! :D
  field :space_time_format_selected, type: Boolean
  field :data_series_selected, type: Boolean

  # Attachment that will be produced is something that is in the JoinedUpData format
  mount_uploader :attachment, DatasetFileUploader

  def import file, user, open_workspace
    values_extracted = SmarterCSV.process file.path
    keys = []
    values_extracted.each do |val|
      val.keys().each do |_key|
        keys << _key if !keys.include?(_key)
      end
    end

    column_keys = []
    keys.each_with_index do |key, index|
      column_keys << {key: key, column: ('A'..'Z').to_a[index], format_type: nil, types_of_data: nil, data_serie_slug: nil }
    end

    self.data_extract = { value_extract: values_extracted, header_definitions: column_keys }
    self.user = user
    self.open_workspace = open_workspace
    # logger.debug "values >> #{headers}"
    if self.save
      logger.debug "Saved preliminary dataset"
    end
  end

  validates :name, presence: true, if: :correct_or_name?
  validates :source_of_data, presence: true, if: :correct_or_name?
  validates :data_choice_made, presence: true, if: :correct_or_data_choice?
  validates :space_time_format_selected, presence: true, if: :correct_or_time_space_format_choices?
  validates :data_series_selected, presence: true, if: :correct_or_dataseries?

  def correct?
    # this checks that all fields have properly been added
    status == 'all_fields'
  end

  def correct_or_name?
    status  == 'name_of_joined_up_dataset' || correct?
  end

  def correct_or_data_choice?
    status == 'data_choice' || correct?
  end

  def correct_or_dataseries?
    status == 'data_series_choice' || correct?
  end

  def correct_or_time_space_format_choices?
    status == 'time_space_format_choice' || correct?
  end

end
