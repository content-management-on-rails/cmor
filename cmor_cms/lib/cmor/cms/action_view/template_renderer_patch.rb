module ActionView
  module TemplateRendererPatch
    def self.included(base)
      base.class_eval do
        alias_method :original_render, :render
        if Rails::VERSION::MAJOR < 4
          def render(context, options)
            @view = context
            @details = extract_details(options)
            extract_format(options[:file] || options[:template], @details)
            template = determine_template(options)
            context = @lookup_context

            unless context.rendered_format
              context.formats = template.formats unless template.formats.empty?
              context.rendered_format = context.formats.first
            end

            layout = template.layout if template.respond_to?(:layout)
            layout ||= options[:layout]

            render_template(template, layout, options[:locals])
          end
        elsif Rails::VERSION::MAJOR < 5
          def render(context, options)
            @view = context
            @details = extract_details(options)
            template = determine_template(options)

            prepend_formats(template.formats)

            @lookup_context.rendered_format ||= (template.formats.first || formats.first)

            layout = template.layout if template.respond_to?(:layout)
            layout ||= options[:layout]

            render_template(template, layout, options[:locals])
          end
        elsif Rails::VERSION::MAJOR < 6
          def render(context, options)
            @view    = context
            @details = extract_details(options)
            template = determine_template(options)
            layout   = template.respond_to?(:layout) && template.layout.present? ? template.layout : options[:layout]

            prepend_formats(template.formats)

            @lookup_context.rendered_format ||= (template.formats.first || formats.first)

            render_template(template, layout, options[:locals])
          end
        else
          def render(context, options)
            @details = extract_details(options)
            template = determine_template(options)
      
            prepend_formats(template.format)

            layout = (template.respond_to?(:layout) ? template.layout : nil) || options[:layout]
            render_template(context, template, (layout || options[:layout]), options[:locals] || {})
          end
        end
      end
    end
  end
end

ActionView::TemplateRenderer.send(:include, ActionView::TemplateRendererPatch)
