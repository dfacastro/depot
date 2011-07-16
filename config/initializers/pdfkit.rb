PDFKit.configure do |config|
 config.wkhtmltopdf = Rails.root.join('vendor', 'plugins\wkhtmltopdf\wkhtmltopdf.exe').to_s# if RAILS_ENV == 'production'
   config.default_options = {
	:page_size => 'A4',
	:print_media_type => true
  }
   #config.wkhtmltopdf = 'C:\Ruby192\lib\ruby\gems\1.9.1\gems\wkhtmltopdf-binary-0.9.5.3\bin'
  # config.default_options = {
  #   :page_size => 'Legal',
  #   :print_media_type => true
  # }
  # config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end