class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :omniauthable,
    :lockable, :trackable

  has_one_attached :avatar
  has_person_name

  has_many :notifications, as: :recipient
  has_many :services

  has_many :participants, dependent: :destroy
  has_many :video_calls, through: :participants

  enum user_role: [:patient, :admin, :staff, :provider]
end
