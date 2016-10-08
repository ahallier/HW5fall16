# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

# Add a declarative step here for populating the DB with movies.

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  page.all("input[type='checkbox']").each{|box| box.set(false)}
  arg1.split(", ").each {|x| find(:css, "#ratings_#{x}").set(true)}
  click_button "Refresh"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = page.all('table#movies td:nth-child(2)').map{|td| td.text}
  expect((ratings-arg1.split(", ")).empty?).to be_truthy
end

Then /^I should see all of the movies$/ do
  movie_array = []
  Movie.find_each{ |movie| movie_array << movie.title}
  titles = page.all('table#movies td:nth-child(1)').map{|td| td.text}
  expect((movie_array-titles).empty?).to be_truthy
end

When /^I have selected the sort by title button/ do 
    click_link("title_header")
end

Then /^I should see "(.*?)" before "(.*?)"/ do |movie1, movie2|
  titles = page.all('table#movies td:nth-child(1)').map{|td| td.text}
  expect(titles.index(movie1) < titles.index(movie2)).to be_truthy
end

When /^I have selected the sort by date button/ do 
    click_link("release_date_header")
end
