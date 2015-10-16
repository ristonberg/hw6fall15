# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

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


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  ratings=arg1.split(", ")
  ratings.each do |rating|
    check "ratings_#{rating}"
  end    
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  result=false
  ratings=arg1.split
  all("tr").each do |tr|
      if (tr.has_content?(ratings[0]) or tr.has_content?(ratings[1]))
          result=true
      else
          result=false
      end
  end
  expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
  count=Movie.count('title')
  rows=0
  all("tr").each do |tr|
      rows=rows+1
  end
  rows=rows-1
  rows.should==count
end

When /^I have chosen to sort the movies by title$/ do
    click_on "title_header"
end


When /^I have chosen to sort the movies by release date$/ do
    click_on "release_date_header"
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |title1, title2|
    result=false
    seen=false
    count=0
    all("tr").each do |tr|
        count+1
        if tr.has_content?(title1)
            seen=true
        elsif tr.has_content?(title2)
            if seen==false
                result=false
                break
            elsif seen==true
                result=true
                break
            end
        end
    end
    expect(result).to be_truthy
end
