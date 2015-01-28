class TimeValidator < ActiveModel::Validator
  def validate record

    # get headers for record
    header_definitions = record.data_extract[:header_definitions]
    format_type_of_data = nil
    _index = nil
    header_definitions.each_with_index do |key, index|
      if key['types_of_data'] == 'time'
        format_type_of_data = key['format_type']
        _index = index
      end
    end


    correct_data = true

    if !_index.nil?
      record.data_extract[:value_extract].each do |value_extract|
        # NOTE:  This works for only ruby version 1.9+
        value = "#{value_extract[value_extract.keys[_index]]}"
        # check value for validity with rules. If one thing is not accurate, repeat!
        # Github Issue #82
        case format_type_of_data
        when "Y"
          # if format_type_of_data == 'Y'
          # check that the record actually is right
          #ISO8601 would have been better :-(
            #YYYY
          correct_data = /^\d{4}$/ === value
          if !correct_data then
            record.errors[:data_extract] << "One of your time values is incorrect. Please use YYYY format!"
            break
          end
        when "M"
          correct_data = /^\d{4}$/ === value
          if !correct_data then
            record.errors[:data_extract] << "One of your time values is incorrect. Please use MM/YYYY"
            break
          end
        when "Q"
          #1) Q1/2014, Q2/2015
          #2) YYYYQ e.g. 20151

          correct_data = /^Q\d{1}\/\d{4}$/ === value or /^\d{5}$/ === value
          if !correct_data then
            record.errors[:data_extract] << "One of your time value is incorrect. To use Quarters, YYYYQ (e.g. 20151 for 1st quarter 2015)"
            break
          end
        else
          puts "All good!"
        end
      end
    end
  end
end




class JoinedUpDataset
  require 'smarter_csv'
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Taggable
  include Mongoid::Timestamps
  include PublicActivity::Model
  include ActiveModel::Validations
  tracked
  # before_save :set_time

  field :created_at, type: Time
  field :edited_at, type: Time

  field :name, type: String
  field :source_of_data, type: String
  field :description, type: String
  field :note, type: String

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

  # data-series related or that are generated from this "joined up data"
  field :data_series_array, type: Array, default: []

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

  validates :name, :description, :source_of_data, presence: true, if: :correct_or_name?
  validates :data_choice_made, presence: true, if: :correct_or_data_choice?
  validates :space_time_format_selected, presence: true, if: :correct_or_time_space_format_choices?
  validates :data_series_selected, presence: true, if: :correct_or_dataseries?

  validates_with TimeValidator

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
