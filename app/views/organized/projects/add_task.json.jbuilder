json.(@task, :id, :name)
json.tableItem render(partial: 'organized/projects/task', locals: { task: @task }, as: :task, formats: [:html])
