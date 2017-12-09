# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sheets
  has_many :boxes
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         # :confirmable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User
end
