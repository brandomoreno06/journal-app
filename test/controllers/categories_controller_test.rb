require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:one)
  end

  test "should go to /categories path (index)" do
    get categories_path

    assert_response :success
  end

  test "should NOT go to /categories path (index) if user is not signed_in" do
    sign_out users(:one)
    get categories_path

    assert_redirected_to new_user_session_path
  end


  test "should show category owned by current user" do
    @category = categories(:one)
    get category_path(@category)
  
    assert_response :success
  end

  test "should NOT show category if user is not signed-in" do
    sign_out users(:one)
    @category = categories(:one)
    get category_path(@category)
    
    assert_redirected_to new_user_session_path, "Categories were shown while user is not signed in."
  end

  test "should NOT show category NOT owned by the user" do
    @category = categories(:one)
    @category_not_owned = categories(:three)
    get category_path(@category_not_owned)
    
    assert_not_equal @category.user_id, @category_not_owned.user_id, "Category is owned by the user"
    assert_redirected_to home_path, "Categories not owned by the user were shown."
  end

  test "should go to /categories/new path" do
    get new_category_path

    assert_response :success
  end

  test "should NOT go to /categories/new path and redirect to sign-in page if user is not signed_in" do
    sign_out users(:one)
    get new_category_path

    assert_redirected_to new_user_session_path
  end

  test "should create a category" do
    assert_difference "Category.count", 1, "Failed to create a category" do
      post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }
    end
  end

  test "should not create a category if category name already exist" do
    post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }

    assert_difference "Category.count", 0, "Created a a category with the same name as with an existing one" do
      post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }
    end

    assert_difference "Category.count", 0, "Created a a category with the same name as with an existing one" do
      post create_category_path params: { category: { name: 'worK', description: "", user_id: users(:one).id } }
    end
  end

  test "should redirect to home path after category creation" do
    post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }
    
    @category = Category.find_by(name: "Work", user_id: users(:one).id)
    assert_redirected_to home_path, "Failed to redirect to home path"
  end


  test "should NOT create a category if user is not signed in" do
    sign_out users(:one)
    assert_difference "Category.count", 0, "Category has been created while user is not signed in" do
      post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }
    end
  end  


  test "should redirect to sign in path if user is not signed_in on category creation" do
    sign_out users(:one)
    post create_category_path params: { category: { name: 'Work', description: "", user_id: users(:one).id } }
    
    assert_redirected_to new_user_session_path, "Creation not halted, should redirect to sign in page"
  end


  test "should re-render new_category if category creation failed" do
    post create_category_path, params: { category: { name: '', description: "", user_id: users(:one).id } }

    assert_template :new, "Failed to create a new category, rendering 'new' template failed"
  end


  test "should redirect to home path after updating category" do
    @category = categories(:one)
    @category.name = "Updated"
    patch update_category_path(@category), params: { category: { name: "#{@category.name}", description: "" } }
    
    assert_redirected_to home_path, "Failed to redirect to /home"
  end

  test "should redirect to sign-in path if user is not signed-in on update" do
    sign_out users(:one)
    @category = categories(:one)
    patch update_category_path(@category), params: { category: { name: "Updated", description: "" } }
    
    assert_not_equal Category.find(@category.id).name, 'Updated', "Updated a category while user is not signed in"
    assert_redirected_to new_user_session_path, "Failed to redirect to sign-in page"
  end

  test "should re-render edit_category template if category update failed" do
    @category = categories(:one)
    patch update_category_path(@category), params: { category: { name: '', description: @category.description } }

    assert_template :edit, "Failed to update category, rendering 'edit' template failed"
  end

  test "should NOT update category if current user is not the owner" do
    @category = categories(:three)
    patch update_category_path(@category), params: { category: { name: 'Updated', description: 'Updated' } }

    assert_not_equal Category.find(@category.id).name, 'Updated', "Updated a category which is not owned by the current user"
    assert_redirected_to home_path, "Failed to redirect to root path"
  end


  test "should NOT update a category if category name already exist" do
    @existing_category = categories(:existing)
    @updating_category = categories(:one)

    patch update_category_path(@updating_category), params: { category: { name: 'Existing', description: 'Updated' } }
    assert_not_equal @existing_category.name, @updating_category.name, "Category has been renamed with the same name as other category"
  end


  test "should NOT update category if user is not signed in" do
    sign_out users(:one)
    @category = categories(:one)
    patch update_category_path(@category), params: { category: { name: 'Updated', description: 'Updated' } }

    assert_not_equal Category.find(@category.id).name, 'Updated', "Updated a category while user is not signed in"
    assert_redirected_to new_user_session_path, "Failed to redirect to sign in path"
  end

  
  test "should delete a category" do
    assert_difference 'Category.count', -1 do
      @category = categories(:one)
      delete category_path(@category)
    end
  end

  test "should NOT delete a category if user is not signed in" do
    sign_out users(:one)
    @category = categories(:one)
    delete category_path(@category)
    assert_not_nil Category.find(@category.id), "Category has been deleted while user is not signed in"
  end

  test "should NOT delete a category if user is not the owner" do
    @category = categories(:three)
    delete category_path(@category)
    assert_not_nil Category.find_by(id: @category.id), "Category has been deleted while user is not signed in"
  end


  test "should raise `ActiveRecord::RecordNotFound` exception" do
    assert_raise ActiveRecord::RecordNotFound do
      @category = Category.find(-1)
      get category_path(@category)
    end
  end
end
