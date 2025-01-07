# inject client concern into scoped models. Do this as late as possible
# to make sure all scoped models are loaded.
Rails.application.config.after_initialize do
  Cmor::Tags::Configuration.taggable_classes.each do |taggable|
    print "[Cmor::Tags] Including Model::Cmor::Tags::TaggableConcern into #{taggable}"
    taggable.send(:include, Model::Cmor::Tags::TaggableConcern)
    puts " => OK"
  end
end
