require 'cpf_cnpj'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_one :personal_info, through: :profile
  has_many :professional_infos, through: :profile
  has_many :education_infos, through: :profile
  has_many :invitation_requests, through: :profile
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: { user: 0, admin: 10 }

  validates :full_name, :citizen_id_number, presence: true
  validates :citizen_id_number, uniqueness: true
  validate :validate_citizen_id_number

  after_create :'create_profile!'
  after_create :subscribe_likes_mailer_job

  def description
    if admin?
      "#{full_name.split(' ').first} (Admin)"
    else
      full_name.split(' ').first.to_s
    end
  end

  def received_post_likes_since(number_of_days)
    posts.map(&:likes).flatten.select do |like|
      like.created_at >= number_of_days.days.ago.at_midnight.getlocal && like.user != self
    end
  end

  def received_comment_likes_since(number_of_days)
    comments.map(&:likes).flatten.select do |like|
      like.created_at >= number_of_days.days.ago.at_midnight.getlocal && like.user != self
    end
  end

  def most_liked_post_since(number_of_days)
    received_post_likes_since(number_of_days)
      .group_by(&:likeable)
      .transform_values(&:count)
      .max_by { |_post, likes_count| likes_count }.first
  end

  def most_liked_comment_since(number_of_days)
    received_comment_likes_since(number_of_days)
      .group_by(&:likeable)
      .transform_values(&:count)
      .max_by { |_comment, likes_count| likes_count }.first
  end

  def received_zero_likes?(number_of_days)
    received_post_likes_since(number_of_days).empty? && received_comment_likes_since(number_of_days).empty?
  end

  private

  def subscribe_likes_mailer_job
    DailyLikesDigestJob.set(wait_until: Date.tomorrow.noon).perform_later(user: self)
  end

  def validate_citizen_id_number
    errors.add(:citizen_id_number, 'inválido') unless CPF.valid?(citizen_id_number)
  end
end
