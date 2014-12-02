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
  has_one :data_serie # related to data series

  belongs_to :open_workspace
  belongs_to :user  # who uploaded

  # TODO -> do post save validations
  # validates :time_value, inclusion: { in: %w(year quarter month)}

  # Attachment that will be produced is something that is in the JoinedUpData format
  mount_uploader :attachment, DatasetFileUploader

  def self.import file, user, open_workspace
    values_extracted = SmarterCSV.process file.path
    # headers = values_extracted[0].keys.map { |i| i.to_s } if values_extracted.size > 0
    # create a joined up dataset (with nil values + attribute it to the uploader and the workspace that sent it.)
    # TODO -> move operation to Sidekiq job

    keys = []
    values_extracted.each do |val|
      val.keys().each do |_key|
        keys << _key if !keys.include?(_key)
      end
    end

    column_keys = []
    keys.each_with_index do |key, index|
      column_keys << {key: key, column: ('A'..'Z').to_a[index], format_type: nil }
    end

    joined_up_dataset = JoinedUpDataset.new
    joined_up_dataset.data_extract = { value_extract: values_extracted, header_definitions: column_keys }
    joined_up_dataset.user = user
    joined_up_dataset.open_workspace = open_workspace
    # logger.debug "values >> #{headers}"
    if joined_up_dataset.save
      logger.debug "Saved preliminary dataset"
    end
  end

  def self.set_header_definitions values
    # this will set the headers and their types
    # e.g.
    # Column A - time_value format; value of that time_value
    # `values` is a hash as well
    self.data_extract["header_definitions"] = values
  end

  # protected
  # def set_time
  #   if created_at.nil?
  #     self.created_at = Time.now
  #   else
  #     self.edited_at = Time.now  # update the edited time
  #   end
  # end

end
