require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    sign_in users(:one)
  end
  
  test "should go to /tasks path" do
    get tasks_path
    
    assert_response :success
  end
  
  test "should NOT go to /tasks path if user is not signed in" do
    sign_out users(:one)
    get tasks_path
    
    assert_redirected_to new_user_session_path, "Failed to redirect to sign in"
  end

  test "should show task details at /categories/:category_id/tasks/:id" do
    @category = categories(:one)
    @task = tasks(:one)
    get category_task_path(@category, @task)
    
    assert_response :success
  end

  test "should NOT show task details if user is not signed in" do
    sign_out users(:one)
    @category = categories(:one)
    @task = tasks(:one)
    get category_task_path(@category, @task)
    
    assert_redirected_to new_user_session_path
  end

  test "should NOT show task details if user is not the owner" do
    @category = categories(:three)
    @task = tasks(:four)
    get category_task_path(@category, @task)
    
    assert_redirected_to home_path, "Task not owned by user has been retreived"
  end

  
  test "should go to /categories/:category_id/tasks/new" do
    @category = categories(:one)
    get new_category_task_path(@category)
    
    assert_response :success, "Failed to go to new_category_task path"
  end

  test "should redirect to new_category_path if user has no existing category" do
    sign_out users(:one)
    sign_in users(:empty)
    get new_task_path
    
    assert_redirected_to new_category_path, "Failed to redirect to new_category path"
  end
  
  test "should redirect to /categories/:category_id/tasks/new when a user has an existing category" do
    @category = users(:one).categories.first
    get new_task_path

    assert_redirected_to new_category_task_path(@category)
  end

  test "should NOT go to /categories/:category_id/tasks/new if user is not signed in" do
    sign_out users(:one)
    @category = Category.first
    get new_task_path

    assert_redirected_to new_user_session_path, "Failed to redirect to sign in page"
  end

  test "should create a task" do
    @category = categories(:one)

    assert_difference 'Task.count', 1 do
      post create_task_path(@category), params: { task: 
                                                      { name: 'New Task',
                                                        details: 'Details',
                                                        due_date: Date.current
                                                     } 
                                                    }
    end
  end

  test "redirect to home path after task creation" do
    @category = categories(:one)
    post create_task_path(@category), params: { task: 
                                                    { name: 'New Task',
                                                      details: 'Details',
                                                      due_date: Date.current,
                                                    } 
                                                  }
    assert_redirected_to home_path, "Failed to redirect to home page"
  end

  test "should NOT create a task if user is not signed in " do
    sign_out users(:one)
    @category = categories(:one)

    assert_difference 'Task.count', 0 do
      post create_task_path(@category), params: { task: 
                                                      { name: 'New Task',
                                                        details: 'Details',
                                                        due_date: Date.current,
                                                      } 
                                                    }
    end
  end

  test "should NOT create a task if user is not the category owner " do
    @category = categories(:three)

    assert_difference 'Task.count', 0, "Created a task for a category not owned by the user" do
      post create_task_path(@category), params: { task: 
                                                      { name: 'New Task',
                                                        details: 'Details',
                                                        due_date: Date.current,
                                                      } 
                                                    }
    end
  end

  test "should re-render 'new' template if task creation failed" do
    @category = categories(:one)
    post create_task_path(@category), params: { task: 
                                                    { name: '',
                                                      details: 'Details',
                                                      due_date: Date.current - 1.day, 
                                                    } 
                                                  }
    
    assert_template :new, "Failed to create a new task, rendering 'new' template failed"
  end


  test "should get form at /categories/:category_id/tasks/:id/edit to edit a task" do
    @category = categories(:one)
    @task = tasks(:three)
    get edit_category_task_path(@category, @task)

    assert_response :success
  end

  test "should NOT get /categories/:category_id/tasks/:id/edit if user is not signed in" do
    sign_out users(:one)
    @category = categories(:one)
    @task = tasks(:three)
    get edit_category_task_path(@category, @task)

    assert_redirected_to new_user_session_path
  end

  test "should NOT update a task if user is not the owner" do
    @category = categories(:three)
    @task = tasks(:four)

    assert_difference "Task.count", 0, "Updated a task not owned by the user" do
      patch update_task_path(@category, @task), params: { task: 
                                                          { name: "Updated Name" ,
                                                            details: "Updated Details",
                                                            due_date: Date.current
                                                          } }
    end
  end

  test "redirect to /categories/:category_id/tasks path after updating a task" do
    @category = categories(:one)
    @task = tasks(:one)
    patch update_task_path(@category, @task), params: { task: 
                                                  { name: "Updated Name" ,
                                                    details: "Updated Details",
                                                    due_date: Date.current
                                                  } }
    
    assert_redirected_to home_path, "Failed to redirect to home page"
  end


  test "re-render edit task template if task update failed" do
    @category = categories(:one)
    @task = tasks(:one)
    patch update_task_path(@category, @task), params: { task: 
                                                  { name: "" ,
                                                    details: "Updated Details",
                                                    due_date: Date.current
                                                  } }

    assert_template :edit, "Failed to update task, rendering 'edit' template failed"
  end

  
  test "should fail to update task if due_date had passed and not rescheduled" do
    @category = categories(:one)
    @task = tasks(:one)
    patch update_task_path(@category, @task), params: { task: 
                                                  { name: "Updated Name" ,
                                                    details: "Updated Details",
                                                    due_date: Date.current - 1
                                                  } }

    assert_template :edit, "Failed to update task, rendering 'edit' template failed"
  end

  test "should destroy task" do
    @category = categories(:one)
    @task = tasks(:one)
    delete category_task_path(@category, @task)
    assert_nil Task.find_by(id: @task.id), "Task has not been destroyed"
  end

  test "should NOT destroy task if user is not signed in" do
    sign_out users(:one)
    @category = categories(:one)
    @task = tasks(:one)
    delete category_task_path(@category, @task)
    assert_not_nil Task.find_by(id: @task.id), "Task has not been destroyed"
  end

  test "should NOT destroy task if user is not the owner" do
    @category = categories(:three)
    @task = tasks(:four)
    delete category_task_path(@category, @task)
    assert_not_nil Task.find_by(id: @task.id), "Task not owned by the user has not been destroyed"
  end

  test "should redirect to home page after destroying" do
    @category = categories(:one)
    @task = tasks(:one)
    delete category_task_path(@category, @task)

    assert_redirected_to home_path, "Failed to redirect to home page"
  end

  test "should rescue `ActiveRecord::RecordNotFound` exception" do
    assert_raise ActiveRecord::RecordNotFound do
      @category = categories(:one)
      @task = Task.find(-1)
      get category_task_path(@category, @task)
    end
  end

  #TEST FOR ON CHANGE OF CATEGORY WHEN ADDING TASK 
end