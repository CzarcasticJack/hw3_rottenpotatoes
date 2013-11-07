# Add a declarative step here for populating the DB with movies.

 Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
# assert false, "Unimplmemented"
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2.
  # page.content is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}.*/m
  regexp.should =~ page.body
end

# Make it easier to express checking or unchecking several boxes at once
# "When I uncheck the following ratings: PG, G, R"
# "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(%r{,\s*})
  ratings.each do |rating|
    if uncheck
      steps(%(When I uncheck "ratings[#{rating}]"))
    else
      steps(%(When I check "ratings[#{rating}]"))
    end
  end
end

Then /I should see all of the movies/ do
  rows = page.all('table tbody tr').size
  numMovies = Movie.find(:all).count
  rows.should == numMovies
end

Then /I should see no movies/ do
  rows = page.all('table tbody tr').size
  rows.should == 0
end

Then /the movies should be sorted alphabetically/ do
  check_sorted Movie.all(:order => :title)
end

def check_sorted(sortedList)
  sortedList.each_cons(2) do |x,y|
    steps %Q(Then I should see "#{x.title}" before "#{y.title}")
  end
end


When /all the movies are displayed/ do
  steps "When I check the following ratings: PG, R, G, PG-13"
  steps "And I press \"Refresh\""
end

When /the movies should be sorted in increasing order of release date/ do
  check_sorted Movie.all(:order => :release_date)
end
