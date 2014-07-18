$: << Dir.pwd
require "lib/high_chart_converter"
require 'open-uri'
require 'lib/doc_name'
require 'nokogiri'

RSpec.describe HighChartConverter do

  #REX Create specs for empty cases. As in if there are no images in the document. Or no Json. Use multiple 'contexts'
  before(:context) do
    @doc_obj = DocName.new
    params={
      "input_file_name" => "Chart_context_menu.html"
    }
    @obj = HighChartConverter.new(params)
    @doc_obj.set_doc_name(params["input_file_name"])
  end

  it "should be instance" do
    expect(@obj).to be_an_instance_of(HighChartConverter)    
  end

  it "should be valid nokogiri document" do
    expect(@obj.fetch_document).to be_an_instance_of(Nokogiri::HTML::Document)
  end

  it "should convert to and save image" do
    expect(@obj.convert_to_image.gsub(" ","").length % 4).to eq(0)   
    # This is now checking that if it converted to valid base64 image string
  end

  it "should not raise exception saving html" do
    expect{@obj.save_result_html_doc}.to_not raise_error(Exception)
  end

  it "should save result html" do
    expect(URI.parse(@obj.save_result_html_doc)).to be_an_instance_of(URI::HTTP)
  end

  it "should not raise exception converting to word doc" do
    expect{@obj.convert_to_word_doc}.to_not raise_error(Exception)    
  end

  it "should convert to word doc" do
    expect(URI.parse(@obj.convert_to_word_doc)).to be_an_instance_of(URI::HTTP)
  end

  it "should fetch and save word doc locally" do
    expect(@obj.fetch_and_save_word_doc).to eq(nil)
  end

  it "should not raise exception fetch and save word doc locally" do
    expect{@obj.fetch_and_save_word_doc}.to_not raise_error(Exception)
  end
end

RSpec.describe HighChartConverter do

  before(:context) do
    @doc_obj = DocName.new
    params={
      "input_file_name" => "Chart_context_menu_empty.html"
    }
    @obj = HighChartConverter.new(params)
    @doc_obj.set_doc_name(params["input_file_name"])
  end

  it "check if document don't have charts" do
    expect(@obj.fetch_document.css('svg').count).to eq(0)
  end
  
  it "check if output html document contain images" do
    @obj.fetch_document
    @obj.convert_to_image
    @obj.save_result_html_doc
    doc = Nokogiri::HTML(open(@doc_obj.output_html_file_name))
    expect(doc.css('img').count).to eq 0
  end

end