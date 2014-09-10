class Message
  include Mongoid::Document
  field :content, type: String
  validates :content, presence: true
  belongs_to :open_workspace
  belongs_to :user
end
