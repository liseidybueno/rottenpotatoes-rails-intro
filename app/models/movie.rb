class Movie < ActiveRecord::Base
  
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
#   def self.with_ratings(ratings)
#     if !ratings.empty?
#       return Movie.where(rating: ratings)
#     end
     
#     return Movie.all
#   end
  
end
