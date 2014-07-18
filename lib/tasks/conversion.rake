require "iron_worker_ng"
require 'fileutils'
require 'rspec'

namespace :converter do
  desc "To Upload worker to iron io"
  task :upload_worker, :worker_name  do |task, args|
    client = IronWorkerNG::Client.new
    code_from_workerfile = IronWorkerNG::Code::Base.new(:workerfile => args[:worker_name])
    puts code_from_workerfile.name
    client.codes.create(code_from_workerfile)
    puts "Worker Uploaded"
  end

  desc "To schedule worker to iron io"
  task :schedule_task, :worker_name, :input_file_name do |task, args|
    client = IronWorkerNG::Client.new
    code_from_workerfile = IronWorkerNG::Code::Base.new(:workerfile => args[:worker_name])
    puts code_from_workerfile.name
    client.tasks.create(code_from_workerfile.name,"input_file_name"=>args[:input_file_name])
    puts "Task Scheduled"
  end

  desc "Remove Temporary files"
  task :remove_files do

    FileUtils.rm_r 'tmp' if File.directory?('tmp')
    FileUtils.rm_r 'output' if File.directory?('output')

    puts "All unnecessary files removed"
  end
  
  desc "Run Rspec Tests"
  task :run_specs do
    RSpec::Core::Runner.run(['spec/doc_high_chart_converter_spec.rb','spec/docx_aws_s3_spec.rb','spec/doc_name_spec.rb'])
  end
end