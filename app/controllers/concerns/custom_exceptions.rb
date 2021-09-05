module CustomExceptions
  class UnauthorizedError < StandardError; end
  class NotUniqueCategoryError < StandardError; end
  class NotUniqueEditCategoryError < StandardError; end
end