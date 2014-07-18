$: << Dir.pwd
require "lib/high_chart_converter"


params={
  "input_file_name" => "Chart_context_menu.html"
}
puts params
@obj = HighChartConverter.new(params)
@obj.run