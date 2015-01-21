#fix for JSON gem/activesupport bug. More info: http://stackoverflow.com/questions/683989/how-do-you-deal-with-the-conflict-between-activesupportjson-and-the-json-gem
if defined?(ActiveSupport::JSON)
  [Object, Array, FalseClass, Float, Hash, Integer, NilClass, String, TrueClass].each do |klass|
    klass.class_eval do
      def to_json(*args)
        super(args)
      end
      def as_json(*args)
        super(args)
      end
    end
  end
end

require './lib/open_night'

###
# Compass
###

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

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def open_night_status_label(open_night)
    case(open_night.go_ahead?)
    when true
      label_class="success"
      label_message="Open"
    when false
      label_class="danger"
      label_message="Closed"
    else
      label_class="default"
      label_message="Stand by"
    end
    content_tag(:span, :class => "label label-#{label_class}") do
      label_message
    end
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host   = 'wholemeal.co.nz'
  deploy.path   = '/home/malc/websites/cas.org.nz'
end
