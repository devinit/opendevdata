class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :content, type: String
  validates :content, presence: true
  belongs_to :open_workspace
  belongs_to :user
end
