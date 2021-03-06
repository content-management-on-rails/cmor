Cmor::Tags.configure do |config|
  # Set the base controller
  #
  # Default: config.base_controller = '<%= base_controller_class_name %>'
  #
  config.base_controller = '<%= base_controller_class_name %>'

  # Add a submit button to the tag search box.
  #
  # Default: config.add_submit_button_to_search_box = true
  # 
  config.add_submit_button_to_search_box = true

  # Use exact search by default or not.
  #
  # Default: config.tag_search_exact_default_value = false
  # 
  config.tag_search_exact_default_value = false

  # Specify the models to be tagged.
  # 
  # Default: config.taggable_class_names = <%= taggable_class_names %>
  #
  config.taggable_class_names = <%= taggable_class_names %>

  # Factory name to use for taggable objects.
  #
  # Default: config.taggable_factory_name = <%= taggable_factory_name %>
  #
  config.taggable_factory_name = <%= taggable_factory_name %>
end
