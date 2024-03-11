module Cmor
  module UserArea
    module Frontend
      class FeatureSpecsGenerator < Rails::Generators::Base
        desc "Generates feature specs"

        source_root Cmor::UserArea::Frontend::Engine.root.join("spec")

        def generate_feature_specs
          directory "features", "spec/features"
        end
      end
    end
  end
end
