class Lasha::User < ApplicationRecord
  self.table_name = "users"
  rolify role_cname: "Role", role_join_table_name: "users_roles"

  devise :database_authenticatable,
         :async,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable,
         # :lockable,
         # :timeoutable,
         :omniauthable,
         omniauth_providers: %i[facebook google_oauth2]

  # include DeviseTokenAuth::Concerns::ActiveRecordSupport
  # include DeviseTokenAuth::Concerns::User
  devise :omniauthable # , omniauth_providers: %i[facebook google_oauth2]

  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true, email: true

  after_create :touch_last_activity

  def full_name
    if first_name.present? || last_name.present?
      [first_name, last_name].compact.join(" ")
    else
      email
    end
  end

  def avatar_gravatar(size = 40)
    avatar.attached? ? avatar.variant(resize: size) : gravatar_image_url(email, size: size)
  end

  def admin?
    has_role?(:admin)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"])
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      name_array = auth.info.name.split(" ")
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0, 20]
      user.first_name = name_array.first
      user.last_name  = name_array.slice(1..-1).join(" ")

      file = Tempfile.new("tmp_file", Rails.root.join("tmp"))
      begin
        file.binmode
        file.write(HTTP.follow.get("#{auth.info.image}?type=large&width=800&height=800"))
        file.rewind
        user.avatar.attach(io: file, filename: "avatar.jpg")
      ensure
        file.close
        file.unlink
      end

      user.validate_and_initialize_role(:client)
      user.confirm
    rescue ActiveRecord::RecordNotUnique => _e
      user
    end
  end

  def self.find_or_create_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create.tap do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name

      file = Tempfile.new("tmp_file", Rails.root.join("tmp"))
      begin
        file.binmode
        file.write(HTTP.follow.get("#{auth.info.image}?type=large&width=800&height=800"))
        file.rewind
        user.avatar.attach(io: file, filename: "avatar.jpg")
      ensure
        file.close
        file.unlink
      end

      user.validate_and_initialize_role(:client)
      user.confirm
    rescue ActiveRecord::RecordNotUnique => _e
      user
    end
  end

  private

    def gravatar_image_url(email, gravatar_overrides = {})
      email = email.strip.downcase if email.is_a? String
      GravatarImageTag.gravatar_url(email, gravatar_overrides)
    end

    def touch_last_activity
      touch :last_activity_at
    end

    # monkey patch for devise_token_auth
    def send_confirmation_notification?
      true
    end
end
