class TasksRepository
  def initialize(db)
    @tasks = db[:tasks]
  end

  def add_new_task(task)
    @tasks.insert(:task => task)
  end

  def read_all_rows
    @tasks.all
  end

  def update(id, updates)
    @tasks.where("id = #{id}").update(updates)
  end

  def delete(id)
    @tasks.where(:id => id).delete
  end

  def find_task_by_id(id)
    @tasks[:id => id]
  end

  def find_all_tasks
    @tasks.select(:task).to_a
  end
end