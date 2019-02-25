class Movie < ActiveRecord::Base
	def self.ratings
		Movie.select(:rating).distinct.inject([]) { |key, m| key.push m.rating }
	end
end
