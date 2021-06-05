class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :book
	has_many :book_comments, dependent: :destroy

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end
	
	def self.search(search, word)
		if search == "forward_match"
			@book = Book.where("title LIKE?","#{word}%")
		elsif search == "backward_match"
			@book = Book.where("title LIKE?","%#{word}")
		elsif search == "perfect_match"
			@book = Book.where("#{word}")
		elsif search == "partial_match"
			@book = Book.where("title LIKE?","%#{word}%")
		else
			@book = Book.all
		end
	end
	
	# def self.last_week
	# 	from = Time.current.at_beginning_of_day
	# 	to = (from + 6.day).at_end_of_day
	# 	@books = Favorite.where(created_at: from...to)
	# end
	
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
end
