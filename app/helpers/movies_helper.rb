module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sort_link(column, title = nil)
	link_to "#{title}", movie_path(:sort_column => 'title')
  end
end
