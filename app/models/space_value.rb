class SpaceValue
  include Mongoid::Documet
  include Mongoid::Slug

  before_save :set_time

  field :created_at, type: Time
  field :edited_at, type: Time
  field :val, type: String

  validates :val, inclusion: { in: %w(region district county sub_county parish village installation)}


  protected
  def set_time
    if created_at.nil?
      self.created_at = Time.now
    else
      self.edited_at = Time.now  # update the edited time
    end
  end

end
