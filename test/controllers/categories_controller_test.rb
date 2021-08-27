require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  test "should go to /categories path" do
    get categories_path

    assert_response :success
  end

  test "should go to /categories/new path" do
    get new_category_path

    assert_response :success
  end

  test "should redirect to /categories path after category creation" do
    post create_category_path params: { category: { name: 'Work' } }
    
    assert_redirected_to categories_path, "Failed to redirect to /categories"
  end

  test "should re-render new_category if category creation failed" do
    post create_category_path, params: { category: { name: '' } }

    assert_template :new, "Failed to create a new category, rendering 'new' template failed"
  end

  test "should show category" do
    @category = categories(:one)
    get category_path(@category)
    
    assert_response :success
  end

  test "should redirect to /categories path after updating category" do
    @category = categories(:one)
    @category.name = "Updated"
    patch update_category_path(@category), params: { category: { name: "#{@category.name}" } }
    
    assert_redirected_to categories_path, "Failed to redirect to /categories"
  end

  test "should re-render edit_category template if category update failed" do
    @category = categories(:one)
    patch update_category_path(@category), params: { category: { name: '' } }

    assert_template :edit, "Failed to update category, rendering 'edit' template failed"
  end

  test "should raise `ActiveRecord::RecordNotFound` exception" do
    assert_raise ActiveRecord::RecordNotFound do
      @category = Category.find(-1)
      get category_path(@category)
    end
  end
end
