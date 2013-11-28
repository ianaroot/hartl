include ApplicationHelper

def valid_signin(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  cookies[:remember_token] = user.remember_token
end

def valid_signup
        fill_in "Name",     with: "example user"
        fill_in "Email",    with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
end  

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_title do |text|
  match do |page|
    page.should have_selector('title', text: text)
  end
end


RSpec::Matchers.define :have_heading do |heading|
  match do |page|
    page.should have_selector('h1', text: heading)
  end
end

RSpec::Matchers.define :list_error do |message|
  match do |page|
    page.should have_selector('li', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

