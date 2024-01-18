class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  def self.search_by_full_name(query)
    where('full_name LIKE ?',
          "%#{sanitize_sql_like(query)}%")
  end
end
