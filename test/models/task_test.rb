require "test_helper"

class TaskTest < ActiveSupport::TestCase

  test "should not save new task without name" do
    category = categories(:one)
    task = category.tasks.build
    task.due_date = "2021-11-19"
    
    assert_not task.save, "Task has been saved without a name"
  end

  test "should not save new task without due_date" do
    category = categories(:one)
    task = category.tasks.build
    task.name = "test"
    
    assert_not task.save, "Task has been saved without due_date"
  end


  test "should not save new task without category id" do
    task = Task.new
    task.name = "taskname"
    task.details= "test details"
    task.due_date = "2021-11-19"
    assert_not task.save, "Task has been saved without a category"
  end


  test "should destroy related tasks when a category is destroyed" do
    category = categories(:one)
    category.destroy
    tasks = Task.where(category: category.id)
    assert_empty tasks, "Related tasks are not destroyed when a category is destroyed"
  end


  test "should not save new task if due_date is passed" do
    category = categories(:one)
    task = category.tasks.build
    task.name = "test"
    task.due_date = "2020-11-19"
    assert_not task.save, "Task is saved with past due date"
  end
end
