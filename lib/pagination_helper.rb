require 'sinatra/base'
require 'will_paginate/view_helpers'
require 'will_paginate/view_helpers/link_renderer'

module Sinatra
  module Pagination
    module Helpers
      include WillPaginate::ViewHelpers

      def will_paginate(collection, options = {})
        options = options.merge(:renderer => MyLinkRenderer) unless options[:renderer]
        super(collection, options)
      end
    end

    class MyLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
      protected

      def page_number(page)
        unless page == current_page
          tag(:li, link(page, page, :rel => rel_value(page)))
        else
          tag(:li, tag(:p, page), :class => 'current')
        end
      end

      def gap
        '<li class="gap">&hellip;</li>'
      end

      def previous_or_next_page(page, text, classname)
        if page
          tag(:li, link(text, page), :class => classname)
        else
         tag(:li, tag(:p, text), :class => classname + ' disabled')
        end
      end

      def html_container(html)
        tag(:ul, html, container_attributes)
      end

      def url(page)
        str = request.path_info.gsub(/\/\d+$/, '')
        str << "/#{page}"
      end

      def request
        @template.request
      end
    end

    def self.registered(app)
      app.helpers Helpers
    end
  end

  register WillPaginate
end
