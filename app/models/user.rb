class User
  include Mongoid::Document
  include Mongoid::Slug
  rolify

  before_save :set_name_and_case

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable, :confirmable

  devise :omniauthable, omniauth_providers: [:facebook, :twitter]

  ## More user information
  field :first_name,         type: String
  field :last_name,         type: String
  slug :last_name

  # field :organization,         type: String, default: ""

  ## banned status
  field :banned, type: Boolean, default: false

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  ## Omniauth stuff
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :api_token, type: String

  validates :first_name, :last_name, presence: true

  has_many :datasets, dependent: :delete
  has_many :documents, dependent: :delete

  has_many :memberships, dependent: :destroy

  def workspaces
    # get the workspaces this user belongs to
    Workspace.in id: memberships.map(&:workspace_id)
  end

  def is_admin?
    self.has_role? :admin
  end

  # # workspaces can have admins that can do stuff to them
  # def is_workspace_admin?
  #   self.has_role? :workspace_admin
  # end

  # def make_workspace_admin!
  #   self.add_role :workspace_admin
  # end

  def is_banned?
    self.banned
  end

  def ban_user!
    self.banned = true
  end

  def unban_user!
    self.banned = false
  end

  def build_token
    begin
      token = SecureRandom.urlsafe_base64
    end while User.exists? api_token: token
    token
  end

  def full_name
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def make_admin
    self.add_role :admin
  end

  def remove_admin
    self.remove_role :admin
  end

  def self.find_for_facebook_oauth auth, signed_in_resource=nil
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(first_name:auth.extra.raw_info.first_name,
        last_name: auth.extra.raw_info.last_name,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20]
        )
    end
    user
  end

  def self.new_with_session params, session
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  protected
    def set_name_and_case
      self.first_name = self.first_name.capitalize
      self.last_name = self.last_name.capitalize
      # self.name = full_name
    end

end
