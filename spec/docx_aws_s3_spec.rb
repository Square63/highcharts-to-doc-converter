$: << Dir.pwd
require "lib/aws_s3.rb"

RSpec.describe AwsS3 do
	before(:context) do
		@aws_s3_obj = AwsS3.new
	end
	it "should be an instance of AwsS3" do   #rex descriptions for these
		expect(@aws_s3_obj).to be_an_instance_of(AwsS3)
	end
	it "check for successfull connection established" do
		expect{@aws_s3_obj.establish_connec}.to_not raise_error(Exception)
	end
	it "should store output png image" do
		expect(@aws_s3_obj.store_object("output/out_0.png")).to be_an_instance_of(String)
	end
	it "should read png image" do
		expect(@aws_s3_obj.read_object("output/out_0.png")).to be_an_instance_of(AWS::S3::S3Object)
	end
	it "should not raise exception while storing" do
		expect{@aws_s3_obj.store_object("output/out_0.png")}.to_not raise_error(Exception)
	end
	it "should not raise exception while reading" do
		expect{@aws_s3_obj.read_object("output/out_0.png")}.to_not raise_error(Exception)
	end

end