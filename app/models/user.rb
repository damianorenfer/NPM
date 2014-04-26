class User < ActiveRecord::Base
  
  has_many :computers, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable
         
  validates :email, uniqueness: true
end
