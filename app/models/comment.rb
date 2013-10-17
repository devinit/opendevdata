class Comment
  include Mongoid::Document

  before_save :set_time, if: Proc.new { |comment| comment.has_no_time? }

  field :content, type: String
  field :created_at, type: Time

  belongs_to :post
  belongs_to :user
  belongs_to :dataset

  validates :content, :user_id, :post_id, presence: true

  def has_no_time?
    created_at == nil
  end

  def set_time
    self.created_at = Time.now
  end

end
