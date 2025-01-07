# inject client concern into scoped models. Do this as late as possible
# to make sure all scoped models are loaded.
Rails.application.config.after_initialize do
  Cmor::Seo::Configuration.resources.keys.each do |resource_class|
    puts "[Cmor::Seo] Including Models::SeoableConcern in #{resource_class}"
    resource_class.constantize.send(:include, Cmor::Seo::Models::SeoableConcern)
    puts " -> [OK]"
  end
end
