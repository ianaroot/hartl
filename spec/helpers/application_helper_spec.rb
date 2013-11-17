require 'spec_helper'
include ApplicationHelper

describe ApplicationHelper do

  describe "full title" do
    it "should includ the page title" do
      full _title("foo").should =~ /foo/
    end

    it "should include the base title" do
      full_title("foo").should =~ /^Ruby on Rails Tutorial Sampple App/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end

  end
end