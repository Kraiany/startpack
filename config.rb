# -*- coding: utf-8 -*-
require 'slim'
Slim::Engine.disable_option_validator!

I18n.enforce_available_locales = true
# general settings
set :encoding, 'utf-8'
set :index_file, 'index.html'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :partials_dir, 'partials'
set :haml, { :format => :html5 }

ignore '*.less'

activate :livereload

activate :directory_indexes



helpers do
  def chapters( post )
    headers = File.readlines( post.source_file ).collect do |x|
      if x =~ /^\#{1,6}\s(.*)/
        $1
      else
        nil
      end
    end.compact

    case markdown_engine
    when :redcarpet
      headers.map { |x| [x, x.downcase.gsub( /\s/, "-" )] }
    when :kramdown
      headers.each_with_index.map { |x,i| [x,i == 0 ? "section" : "section-#{i}"] }
    else
      []
    end
  end

  def button_color(size)
    case size
    when "lg"; then "red-800"
    when "sm"; then "red-400"
    when "xs"; then "red-200"
    else "red-600"
    end
  end

  def button(url, text, size: 'dummy', include:[])
    href="#{base}/#{url}"
    urls = include << url
    "<li class='#{active_class urls}'><a class='btn btn-#{size} btn-raised btn-material-#{button_color(size)}' href='#{href}'>#{text}<div class='ripple-wrapper'></div></a>"
  end

  def button_l(*params, **rest)
    button(*params, size: "lg", **rest)
  end

  def button_s(*params, **rest)
    button(*params, size: "sm", **rest)
  end

  def button_xs(*params, **rest)
    button(*params, size: "xs", **rest)
  end

  def image_caption(image, text)
    %{<figure>
      #{image_tag image}
      <figcaption> #{text} </figcaption>
   </figure>}
  end

  def page_active?(urls)
    urls.each do |url|
      return true if current_page.url.split("/").last == url.split("/").last
    end
    false
  end

  def active_class(url)
    "active" if page_active?(url)
  end
end

# set :markdown, tables: true, autolink: true, gh_blockcode: true, fenced_code_blocks: true, with_toc_data: true, smart: true
# set :markdown_engine, :redcarpet

set :markdown_engine, :kramdown
set :markdown, :layout_engine => :erb,
  :tables => true,
  :autolink => true,
  footnotes: true,
  :smartypants => true,
  smart_quotes: [180, 180, 8222, 8220]

configure :development do
  set :base, ""
  activate :relative_assets
end

configure :build do
  set :base, "/startpack"
  activate :relative_assets
  # activate :directory_indexes
  activate :sprockets
  activate :minify_css
  activate :minify_javascript
  set :relative_links, true
  # somehow minifying html takes some html attributes away so it is causing
  # some css not applied to certain elements... so until we find alternative
  # way to monify html, we will disable this
  #activate :minify_html
  activate :asset_hash
  #activate :gzip
  ignore 'product.html'
  ignore(/Icon\r$/)
  ignore(/\.DS_Store/)
  ignore(/^assets.*\.yml/)
  ignore(/^assets\/stylesheets\/(?!all).*\.css/)
  ignore(/^assets\/javascripts\/(?!all).*\.js/)
  ignore(%r{^assets/stylesheets/colorschemas/.*})
  ignore(%r{^assets/images/homepage-slider/pysanka-.*\.jpg$})
  ignore(%r{/src/})


  # if ENV['CDN_HOST']
  #   activate :asset_host
  #   set :asset_host, ENV['CDN_HOST']
  # end
end
