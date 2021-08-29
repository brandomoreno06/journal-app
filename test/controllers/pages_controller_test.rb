require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should go to /pages path" do
    get pages_path
    assert_response :success
  end
  
  # test "should go to /pages path" do
  #   get pages_path
  #   assert_response :success
  # end
end
