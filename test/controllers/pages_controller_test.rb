require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:one)
  end

  test "should go to /home path" do
    get home_path
    assert_response :success
  end

  test "should not go to home_path if user is not signed in" do
    sign_out users(:one)
    get home_path
    assert_redirected_to new_user_session_path, "Failed to redirect to sugn in page."
  end
end
