# frozen_string_literal: true

module MailHelper
  def frontend_url_for(path)
    options = Rails.configuration.action_mailer.default_url_options
    ActionDispatch::Http::URL.send(:build_host_url, options[:host], options[:port], options[:protocol], options, path)
  end

  def frontend_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    url = frontend_url_for(options)
    html_options['href'] ||= url

    content_tag('a', name || url, html_options, &block)
  end
end
