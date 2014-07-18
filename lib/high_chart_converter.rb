require 'open-uri'
require 'base64'
require 'nokogiri'
require 'phantomjs'
require 'httmultiparty'
require 'lib/aws_s3'
require 'lib/doc_name'

class HighChartConverter

  def initialize(params)
    
    puts "Starting HelloWorker at #{Time.now}"

    @aws_s3_obj = AwsS3.new

    @aws_s3_obj.establish_connec()
    puts params
    @doc_name = params['input_file_name']
    @doc_name_obj = DocName.new
    @doc_name_obj.set_doc_name(@doc_name)
  end

  def run
    @doc = fetch_document
    convert_to_image
    @doc.css('script').last.remove   #removes that script tag which adds highchart
    save_result_html_doc
    convert_to_word_doc
    puts "task ended"
  end

  def fetch_document
    @doc = Nokogiri::HTML(open(@doc_name_obj.input_file_name))
  end

  def convert_to_image
    img_string = ""
    @doc.css('svg').each_with_index do |svg,index|
      File.open(@doc_name_obj.input_json_doc, 'w') do |file|
        file.puts svg
        file.close
      end
      puts Phantomjs.path 

       #REX This width should be read from the image div. Change the .html in the rspec to be two different image sizes to make sure it works.
      r = Phantomjs.run("data/highchart-convert.js", "-infile", @doc_name_obj.input_json_doc, "-outfile", @doc_name_obj.output_image_name(index))
      puts r

      File.open(@doc_name_obj.output_image_name(index), 'r') do|image_file|
        img_string =  Base64.encode64(image_file.read).gsub(/\n/, '')
        new_node = @doc.create_element "img"
        new_node.set_attribute('src', "data:image/png;base64,#{img_string}")
        svg.replace new_node
        image_file.close
      end
    end
    return img_string
  end

  def save_result_html_doc

    File.open(@doc_name_obj.output_html_file_name,'w') do |file|
      file.write @doc.to_html
      file.close
    end

    file = @doc_name_obj.output_html_file_name

    puts file_url = @aws_s3_obj.store_object(file)
    puts "output html file saved"
    return file_url
  end

  def convert_to_word_doc
    #REX Still need to modify the Java servlet to use a password
    response = HTTMultiParty.post(CONFIG["aspose"]["url"],
      query: {
        toHtml: File.read(@doc_name_obj.output_html_file_name),
        appSid: CONFIG["aspose"]["appSid"],
        format: 'html'
      }, 
      :detect_mime_type => true)

    puts response.code

    File.open(@doc_name_obj.output_word_file_name,'wb'){|file|
      file.write response.body if response.code == 200
      file.close
    }

    file = @doc_name_obj.output_word_file_name
    puts word_doc_url = @aws_s3_obj.store_object(file)
    puts "output doc file saved"
    return word_doc_url
  end
  def fetch_and_save_word_doc
    file = @doc_name_obj.output_word_file_name

    document = @aws_s3_obj.read_object(file)
    File.open(@doc_name_obj.test_output_word_file_name,'wb') {|file|
      file.write document.value
      file.close
    }
  end
end