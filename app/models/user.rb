require 'cpf_cnpj'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :full_name, :citizen_id_number, presence: true
  validates :citizen_id_number, uniqueness: true
  validate :validate_citizen_id_number

  enum role: { user: 0, admin: 10 }

  private

  def validate_citizen_id_number
    errors.add(:citizen_id_number, 'inválido') unless CPF.valid?(citizen_id_number)
  end

  def self.search_by_full_name(query)
    where('full_name LIKE ?',
          "%#{sanitize_sql_like(query)}%")
  end

end
