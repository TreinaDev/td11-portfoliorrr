class Project
  attr_accessor :id, :title, :description, :category

  def initialize(id:, title:, description:, category:)
    @id = id
    @title = title
    @description = description
    @category = category
  end
end
