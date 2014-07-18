$: << Dir.pwd
require "lib/doc_name"

RSpec.describe DocName do
	
	before(:context) do
		@doc_name_obj = DocName.new
		@index = 1
	end

	it "check if doc name set correctly" do  #REX descriptions for these
		expect(@doc_name_obj.set_doc_name('abc.html')).to eq(@doc_name_obj.get_doc_name)
	end

	it "check for correct ouput html filename" do
		expect(@doc_name_obj.output_html_file_name).to eq("output/"+@doc_name_obj.get_doc_name.split('.')[0]+'_output.html')
	end

	it "check for correct word filename" do
		expect(@doc_name_obj.output_word_file_name).to eq("output/"+@doc_name_obj.get_doc_name.split('.')[0]+'.docx')
	end

	it "check for correct input json filename" do
		expect(@doc_name_obj.input_file_name).to eq("data/#{@doc_name_obj.get_doc_name}")
	end

	it "check for correct output png image filenames" do
		expect(@doc_name_obj.output_image_name(@index)).to eq("output/out_#{@index}.png")
	end

	it "check for correct test output doc filename" do
		expect(@doc_name_obj.test_output_word_file_name).to eq('output/test_'+@doc_name_obj.get_doc_name.split('.')[0]+'.docx')
	end
end