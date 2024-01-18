class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :full_name, :citizen_id_number, presence: true
  validates :citizen_id_number, uniqueness: true
end
