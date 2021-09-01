require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should not create a new category without a name" do
    category = Category.new
    
    assert_not category.save, "Created a new category without a name"
  end

  test "should create a new category even without description" do
    category = Category.new
    category.name = "Category"
    category.user_id = users(:one).id
    assert category.save, "Could not create a category without a description"
  end

  test "should create a new category without user_id" do
    category = Category.new
    category.name = "Category"

    assert_not category.save, "Created a category without a user_id"
  end
end
