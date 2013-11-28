require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do

    let(:user) {FactoryGirl.create(:user) }

    before(:each) do
      valid_signin(user)
      visit users_path
    end

    it { should have_title("All users") }
    it { should have_heading("All users") }

    describe "pagination" do

      before(:all)  { 30.times { FactoryGirl.create(:user) } }
      after(:all)   { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end       
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          valid_signin( admin )
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: users_path(admin)) }

        describe "attempting to delete self" do
          it "shouldn't work" do
            expect { delete user_path(admin) }.not_to change(User, :count).by(-1) 
          end
        end
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_heading("Sign up") }
    it { should have_title(full_title('Sign up')) }

  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_heading(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
        it { should have_error_message('The form contains 6 errors') }
        it { should list_error("Name can't be blank") }
        it { should list_error("Email can't be blank") }
        it { should list_error("Email is invalid") }
        it { should list_error("Password can't be blank") }
        it { should list_error("Password is too short (minimum is 6 characters") }
        it { should list_error("Password confirmation can't be blank") }
      end
    end

    describe "with valid information" do
      before do
        valid_signup
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }  
    before do
      valid_signin(user)
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_heading("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link("change", href: 'http://gravatar.com/emails') }
      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_error_message('') }
      end
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",     with: new_name
        fill_in "Email",    with: new_email
        fill_in "Password",  with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_success_message('') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

end



