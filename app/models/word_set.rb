class WordSet < ApplicationRecord
    belongs_to :user
    has_many :test
    default_scope -> { order(created_at: :desc) }
    validates :user_id, presence: true
    validates :name, presence: true, length: { maximum: 30}
    serialize :words
        
    #Word set can't be edited after being made public

end
