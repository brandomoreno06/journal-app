require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "go to /tasks path" do
    get tasks_path

    assert_response :success
  end

  test "redirect to /categories/:category_id/tasks/new" do
    @category = Category.first
    get new_task_path

    assert_redirected_to new_category_task_path(@category)
  end

  test "go to /categories/:category_id/tasks/new" do
    @category = categories(:one)
    get new_category_task_path(@category)

    assert_response :success
  end

  test "redirect to /categories/:category_id/tasks path after task creation" do
    @category = categories(:one)
    post create_task_path(@category), params: { task: 
                                                    { name: 'New Task',
                                                      details: 'Details',
                                                      due_date: Date.current 
                                                    } 
                                                  }
    
    assert_redirected_to category_path(@category), "Failed to redirect to /categories/:category_id/tasks"
  end

  test "re-render 'new' template if task creation failed" do
    @category = categories(:one)
    post create_task_path(@category), params: { task: 
                                                    { name: '',
                                                      details: 'Details',
                                                      due_date: Date.current - 1.day 
                                                    } 
                                                  }
    
    assert_template :new, "Failed to create a new task, rendering 'new' template failed"
  end

  test "show task details at /categories/:category_id/tasks/:id" do
    @category = categories(:one)
    @task = tasks(:one)
    get category_task_path(@category, @task)
    
    assert_response :success
  end

  test "get form at /categories/:category_id/tasks/:id/edit to edit a task" do
    @category = categories(:one)
    @task = tasks(:three)
    get edit_category_task_path(@category, @task)

    assert_response :success
  end

  test "redirect to /categories/:category_id/tasks path after updating a task" do
    @category = categories(:one)
    @task = tasks(:one)
    patch update_task_path(@category, @task), params: { task: 
                                                  { name: "Updated Name" ,
                                                    details: "Updated Details",
                                                    due_date: Date.current
                                                  } }
    
    assert_redirected_to category_path(@category), "Failed to redirect to /categories/:category_id/tasks/:id"
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

  test "should redirect to /categories/:id after destroying" do
    @category = categories(:one)
    @task = tasks(:one)
    delete category_task_path(@category, @task)

    assert_redirected_to category_path(@category), "Failed to redirect to /categories/:id"
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