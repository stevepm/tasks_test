require_relative '../lib/tasks_repository'
require 'sequel'

describe 'task repository' do
  DB = Sequel.connect('postgres://gschool_user:password@localhost:5432/tasks_test')

  before do
    DB.create_table! :tasks do
      primary_key :id
      String :task
      Boolean :completed, :default => false
    end
    @tasks = TasksRepository.new(DB)
  end

  it 'creates tasks' do
    @tasks.add_new_task('eat')
    expect(@tasks.read_all_rows).to eq([
                                         {:id => 1, :task => 'eat', :completed => false}
                                       ])
  end

  it 'updates tasks' do
    @tasks.add_new_task('sleep')
    @tasks.add_new_task('eat')
    @tasks.update(1, {:task => 'hello', :completed => true})
    @tasks.update(2, {:task => 'run'})
    expect(@tasks.read_all_rows).to eq([
                                         {:id => 1, :task => 'hello', :completed => true},
                                         {:id => 2, :task => 'run', :completed => false}
                                       ])
  end

  it 'deletes tasks' do
    @tasks.add_new_task('sleep')
    @tasks.add_new_task('eat')
    @tasks.delete(1)
    expect(@tasks.read_all_rows).to eq([
                                         {:id => 2, :task => 'eat', :completed => false}
                                       ])
  end

  it 'finds a task by an id' do
    @tasks.add_new_task('sleep')
    expect(@tasks.find_task_by_id(1)).to eq(
                                           {:id => 1, :task => 'sleep', :completed => false}
                                         )
  end

  it 'finds all of the tasks in the table' do
    @tasks.add_new_task('sleep')
    @tasks.add_new_task('eat')
    @tasks.add_new_task('run')
    @tasks.add_new_task('lift')
    expect(@tasks.find_all_tasks).to eq([
      {:task => 'sleep'},
      {:task => 'eat'},
      {:task => 'run'},
      {:task => 'lift'}
                                        ])
  end
end