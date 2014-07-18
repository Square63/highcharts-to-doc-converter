Instructions
============

### To upload a worker
rake converter:upload_worker["conversion.worker"] 

### Schedule a task to run
rake converter:schedule_task["conversion.worker","Chart_context_menu.html"] 

### Run the task locally
ruby lib/conversion_task.rb  

### Run temporary files
rake converter:remove_files

### Run All Specs
rake converter:run_specs

### Run tests for HighCharts Converter
rspec spec/high_chart_converter_spec.rb

### Run tests for Amazon S3
rspec spec/aws_s3_spec.rb

### Run tests for DocName
rspec spec/doc_name_spec.rb