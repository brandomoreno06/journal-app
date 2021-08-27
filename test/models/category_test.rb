require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should not create a new categoty without a name" do
    category = Category.new
    
    assert_not category.save, "Created a new category without a name"
  end

  test "should create a new categoty even without description" do
    category = Category.new
    category.name = "Category"
    assert category.save, "Could not create category without a description"
  end
end
