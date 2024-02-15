require 'cpf_cnpj'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_one :personal_info, through: :profile
  has_many :professional_infos, through: :profile
  has_many :education_infos, through: :profile
  has_many :invitation_requests, through: :profile

  enum role: { user: 0, admin: 10 }

  validates :full_name, presence: true
  validates :citizen_id_number, presence: true, unless: -> { deleted_at.present? }
  validates :citizen_id_number, uniqueness: true, unless: -> { deleted_at.present? }
  validate :validate_citizen_id_number, unless: -> { deleted_at.present? }

  after_create :'create_profile!'
  after_create :subscribe_likes_mailer_job
  after_create :update_search_name

  def description
    if admin?
      "#{full_name.split(' ').first} (Admin)"
    else
      full_name.split(' ').first.to_s
    end
  end

  def received_post_likes_since(number_of_days)
    return [] if posts.map(&:likes).blank?

    posts.map(&:likes).flatten.select do |like|
      like.created_at >= number_of_days.days.ago.at_midnight.getlocal && like.user != self
    end
  end

  def received_comment_likes_since(number_of_days)
    return [] if comments.map(&:likes).blank?

    comments.map(&:likes).flatten.select do |like|
      like.created_at >= number_of_days.days.ago.at_midnight.getlocal && like.user != self
    end
  end

  def most_liked_post_since(number_of_days)
    return if received_post_likes_since(number_of_days).empty?

    received_post_likes_since(number_of_days)
      .group_by(&:likeable)
      .transform_values(&:count)
      .max_by { |_post, likes_count| likes_count }.first
  end

  def most_liked_comment_since(number_of_days)
    return if received_comment_likes_since(number_of_days).empty?

    received_comment_likes_since(number_of_days)
      .group_by(&:likeable)
      .transform_values(&:count)
      .max_by { |_comment, likes_count| likes_count }.first
  end

  def received_zero_likes?(number_of_days)
    received_post_likes_since(number_of_days).empty? && received_comment_likes_since(number_of_days).empty?
  end

  def delete_user_data
    transfer_posts_and_comments_to(cloned_user)
    destroy
  end

  def active_for_authentication?
    super && !profile.removed?
  end

  def inactive_message
    I18n.t('reports.removed_account')
  end

  private

  def subscribe_likes_mailer_job
    DailyLikesDigestJob.set(wait_until: Date.tomorrow.noon).perform_later(user: self)
  end

  def validate_citizen_id_number
    errors.add(:citizen_id_number, I18n.t('users.model.invalid_cpf')) unless CPF.valid?(citizen_id_number)
  end

  def transfer_posts_and_comments_to(clone)
    posts.each do |post|
      post.update(user: clone, status: 'archived')
    end

    comments.each do |comment|
      comment.update(user: clone, old_message: comment.message, message: 'Comentário Removido')
    end
  end

  def cloned_user
    clone = dup
    clone.full_name = 'Conta Excluída'
    clone.email = "deleted@account-#{id}.com"
    clone.password = SecureRandom.alphanumeric(8)
    clone.citizen_id_number = "deleted-#{SecureRandom.uuid}"
    clone.deleted_at = Time.current
    clone.save!
    clone
  end

  def update_search_name
    update(search_name: I18n.transliterate(full_name, locale: :en))
  end
end
