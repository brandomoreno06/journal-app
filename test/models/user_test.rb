require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not create user with without name, and email" do
    user = users(:empty)

    assert_not user.save, "Created an account without a first_name, last_name or email"
  end


  test "should not create user with name more than required maximum length" do
    user = users(:name_exceeding_maximum)

    assert_not user.save, "Created an account with first_name or last_name exceeding maximum of 20 characters"
  end


  test "should not create user with email not matching the pattern /\A\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,6})+\z/" do
    user = users(:email_not_matching_pattern)

    assert_not user.save, "Created an account with an invalid email"
  end
end
