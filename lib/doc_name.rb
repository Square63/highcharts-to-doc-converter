class DocName

	@doc_name = nil

	def get_doc_name
		@doc_name
	end

	def set_doc_name(doc_name)
		@doc_name = doc_name
	end

  #REX Make sure any generated files are .gitingored
	def output_html_file_name
		"output/"+@doc_name.split('.')[0]+'_output.html'
	end

	def input_json_doc
		"data/"+@doc_name.split('.')[0]+'.json'
	end

	def output_word_file_name
		'output/'+@doc_name.split('.')[0]+'.docx'		
	end
	def input_file_name
		"data/"+@doc_name
	end
	def output_image_name(index)
		"output/out_#{index}.png"		
	end

  # REX why is this getting called in the production code?
	def test_output_word_file_name
		'output/test_'+@doc_name.split('.')[0]+'.docx'
	end
end