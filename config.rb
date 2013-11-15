###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end



###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

###
# Premailer
###

# require 'premailer'
# require 'hpricot'

# module PreMailer
#   class << self
#     def registered(app)
#       require "premailer"
#       app.after_build do |builder|
#         prefix = build_dir + File::SEPARATOR
#         Dir.chdir(build_dir) do
#           Dir.glob('**/*.html') do |file|
#             premailer = Premailer.new(file,
#               :warn_level => Premailer::Warnings::SAFE,
#               :preserve_styles => false,
#               :css_to_attributes => true,
#               :remove_comments => false,
#               :remove_ids => false,
#               :remove_classes => false
#             )
#             fileout = File.open(file, "w")
#             # fileout.puts premailer.to_inline_css
#             fileout.close
#             premailer.warnings.each do |w|
#               builder.say_status :premailer, "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
#             end
#             builder.say_status :premailer, prefix+file
#           end
#         end
#       end
#     end
#     alias :included :registered
#   end
# end

# ::Middleman::Extensions.register(:inline_premailer, PreMailer)

# activate :inline_premailer

###
# Import Styles
###
module ImportStyles
  class << self
    def registered(app)
      app.after_build do |builder|
        prefix = build_dir + File::SEPARATOR
        Dir.chdir(build_dir) do
          Dir.glob('**/*.html') do |file_path|
            file_content = File.read(file_path)
            styles_matches = /<link.*?href=["'](.*?)["'].*?>/.match(file_content)
            if styles_matches
              styles_matches.captures.each_index do |i|
                styles_content = File.read(styles_matches.captures[i])
                file_content.gsub!(styles_matches[i], "<style>\n#{styles_content}\n</style>")
              end
            end  
            File.open(file_path, "w") {|file| file.puts file_content}
            if styles_matches
              builder.say_status :import_styles, prefix+file_path
            end
          end
        end
      end
    end
    alias :included :registered
  end
end
::Middleman::Extensions.register(:import_styles, ImportStyles)
activate :import_styles



###
# Paths
##
set :css_dir, 'Css'
set :images_dir, 'images'

compass_config do |config|
  config.output_style = :expanded
  config.sass_options = {
    :debug_info => false,
    :line_comments => false
  }
end

activate :livereload

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end