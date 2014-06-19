class Organization
  include Mongoid::Document
  field :name, type: String
  field :location, type: String

  # an organization or "workspace" has many datasets
  embeds_many :datasets, validate: false, dependent: :nullify
  embeds_many :documents, validate: false, dependent: :nullify
end
