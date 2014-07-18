require 'aws/s3'
require 'open-uri'
require 'yaml'

CONFIG = YAML.load(File.open('app_config.yml'))[ENV["RAILS_ENV"] || 'test']

class AwsS3

	include AWS::S3
		
		def establish_connec
			AWS::S3::Base.establish_connection!(
		      :access_key_id     => CONFIG["aws_s3"]["access_key"],
		      :secret_access_key => CONFIG["aws_s3"]["secret_key"]
	    )
		end

		def store_object(file_name)
			S3Object.store(file_name, open(file_name), CONFIG["aws_s3"]["bucket_name"])
	  	return S3Object.url_for(file_name, CONFIG["aws_s3"]["bucket_name"])
		end

		def read_object(file_name)
			puts S3Object.exists?(file_name, CONFIG["aws_s3"]["bucket_name"])
	    return S3Object.find(file_name, CONFIG["aws_s3"]["bucket_name"])
		end
end