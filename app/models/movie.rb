class Movie < ActiveRecord::Base
	def self.ratings
		Movie.select(:rating).distinct.inject([]) { |k, m| k.push m.rating }
	end
end
