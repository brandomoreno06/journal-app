const categorySelectForm = document.querySelector("#task_category_id");

const rerouteOnCategoryChange = () => {
  window.location.pathname = `/categories/${categorySelectForm.value}/tasks/new`
}

categorySelectForm.addEventListener('change', () => {
  rerouteOnCategoryChange();
});