require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:one)
  end

  test "should go to /pages path" do
    get root_path
    assert_response :success
  end

  test "should not go to root path if user is not signed in" do
    sign_out users(:one)
    get root_path
    assert_redirected_to new_user_session_path, "Failed to redirect to sugn in page."
  end
end
