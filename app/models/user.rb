
class User < ApplicationRecord
	attr_accessor :remember_token

	validates :name, presence: true,length: {maximum: 50}

	before_save { email.downcase! }
  	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true,length: {maximum: 255},format: {with:VALID_EMAIL_REGEX}, uniqueness: true
	
	has_secure_password
  	validates :password,presence: true, length: { minimum: 6 }

  	def User.digest string
 		cost = if ActiveModel::SecurePassword.min_cost
    		BCrypt::Engine::MIN_COST
 				else
  			BCrypt::Engine.cost
				end
			BCrypt::Password.create string, cost: cost
	end

	class << self
		def new_token
			SecureRandom.urlsafe_base64
		end
	end

	def remember
		self.remember_token = User.new_token
		update_attribute :remember_digest, User.digest(remember_token)
	end

	def authenticated? 
		remember_token BCrypt::Password.new(remember_digest).is_password? remember_token
	end

	def forget
  		update_attribute :remember_digest, nil
	end
end
