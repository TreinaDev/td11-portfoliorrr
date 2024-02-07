class Profile < ApplicationRecord
  belongs_to :user
  has_one :personal_info, dependent: :destroy
  has_many :professional_infos, dependent: :destroy
  has_many :education_infos, dependent: :destroy
  has_many :profile_job_categories, dependent: :destroy

  has_many :followers, class_name: 'Connection', foreign_key: :followed_profile_id, dependent: :destroy,
                       inverse_of: :follower

  has_many :followed_profiles, class_name: 'Connection', foreign_key: :follower_id,
                               dependent: :destroy, inverse_of: :followed_profile

  has_many :connections, foreign_key: :followed_profile_id, dependent: :destroy, inverse_of: :followed_profile

  has_many :job_categories, through: :profile_job_categories
  has_many :invitation_requests, dependent: :destroy

  has_one_attached :photo
  has_many :invitations, dependent: :destroy
  has_many :posts, through: :user
  has_many :reports, dependent: :destroy

  accepts_nested_attributes_for :personal_info
  accepts_nested_attributes_for :professional_infos
  accepts_nested_attributes_for :education_infos

  after_create :create_personal_info!

  validate :valid_photo_content_type, on: :update
  validate :photo_size_lower_than_3mb, on: :update

  enum work_status: { unavailable: 0, open_to_work: 10 }
  enum privacy: { private_profile: 0, public_profile: 10 }

  delegate :full_name, to: :user

  def self.advanced_search(search_query)
    left_outer_joins(:job_categories, :personal_info, :user).where(
      'job_categories.name LIKE :term OR
       personal_infos.city LIKE :term OR
       users.full_name LIKE :term',
      { term: "%#{sanitize_sql_like(search_query)}%" }
    ).public_profile.uniq
  end

  def self.get_profile_job_categories_json(query)
    profiles = search_by_job_categories(query)
    profiles_json = profiles.map do |profile|
      { user_id: profile.user_id, full_name: profile.full_name,
        job_categories: ProfileJobCategory.generate_profile_job_categories_json(profile.id) }
    end
    profiles_json.as_json
  end

  def self.search_by_job_categories(query)
    left_outer_joins(:job_categories, :profile_job_categories).where(
      "job_categories.name LIKE :term OR
      profile_job_categories.description LIKE :term", { term: "%#{sanitize_sql_like(query)}%" }
    ).uniq
  end

  def followers_count
    followers.active.count
  end

  def followed_count
    followed_profiles.active.count
  end

  def following?(profile)
    followers.active.where(follower: profile).any?
  end

  def inactive_follower?(profile)
    followers.inactive.where(follower: profile).any?
  end

  def self.most_followed(limit)
    joins(:followers)
      .where(connections: { status: 'active' })
      .group(:id)
      .order('count(follower_id) DESC, id ASC')
      .limit(limit)
  end

  private

  def valid_photo_content_type
    return if photo.present? && photo.content_type.in?(%w[image/jpg image/jpeg image/png])

    errors.add(:photo, message: 'deve ser do formato .jpg, .jpeg ou .png') if photo.present?
  end

  def photo_size_lower_than_3mb
    return if photo.present? && photo.byte_size <= 3.megabytes

    errors.add(:photo, message: 'deve ter no máximo 3MB') if photo.present?
  end
end

def json_output(profile)
  { data: {
    profile_id: profile.id, email: profile.user.email,
    full_name: profile.full_name, cover_letter: profile.cover_letter,
    professional_infos: profile.professional_infos.as_json(only: %i[company position start_date end_date
                                                                    current_job description]),
    education_infos: profile.education_infos.as_json(only: %i[institution course start_date end_date]),
    job_categories: profile.profile_job_categories.map do |category|
      { name: category.job_category.name, description: category.description }
    end
  } }
end
