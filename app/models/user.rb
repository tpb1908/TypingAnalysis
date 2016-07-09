class User < ApplicationRecord
    attr_accessor :remember_token

	before_save {self.email = email.downcase} #Inside the User model, the self is option on the right side
	validates(:name, presence: true, length: { maximum: 50 })
	VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates(:email, presence: true, length: { maximum: 255 }, 
		format: {with: VALIDATE_EMAIL_REGEX}, uniqueness: { case_sensitive: false })
	has_secure_password
	validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)

	#Hash digest of a given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

    #New random token for cookie
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    #Remembers a user in the database for use in persistent sessions
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    #Returns true if the given token matches the digest
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

end