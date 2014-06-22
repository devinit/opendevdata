class Membership
  include Mongoid::Document
  field :admin, type: Boolean, default: false
  field :approved, type: Boolean, default: false

  belongs_to :user, dependent: :destroy
  belongs_to :workspace, dependent: :destroy

  # validates_uniqueness_of :user_id # TODO -> figure out a better validation!
end
