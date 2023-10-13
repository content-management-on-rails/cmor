require "rails_helper"

RSpec.describe "/de/backend/bilder/picture_galleries", type: :feature, locale: :de do
  let(:resource_class) { Cmor::Galleries::PictureGallery }
  let(:resource) { create(:cmor_galleries_picture_gallery) }
  let(:resources) { create_list(:cmor_galleries_picture_gallery, 3) }

  describe "REST actions" do
    # List
    it {
      resources
      expect(subject).to implement_index_action(self)
    }

    # Create
    it {
      expect(subject).to implement_create_action(self)
        .for(resource_class)
        .within_form("#new_picture_gallery") {
          # fill the needed form inputs via capybara here
          #
          # Example:
          #
          #     select 'de', from: 'slider[locale]'
          #     fill_in 'slider[name]', with: 'My first slider'
          #     check 'slider[auto_start]'
          #     fill_in 'slider[interval]', with: '3'
          fill_in "picture_gallery[name]", with: "My first gallery"
          attach_file "picture_gallery[append_picture_detail_assets][]", [Cmor::Galleries::Engine.root.join(*%w[spec files cmor galleries picture_details example.png])]
          check "picture_gallery[published]"
        }
        .increasing { Cmor::Galleries::PictureGallery.count }.by(1)
    }

    # Read
    it { expect(subject).to implement_show_action(self).for(resource) }

    # Update
    it {
      expect(subject).to implement_update_action(self)
        .for(resource)
        .within_form(".edit_picture_gallery") {
                           # fill the needed form inputs via capybara here
                           #
                           # Example:
                           #
                           #     fill_in 'slider[name]', with: 'New name'
                           fill_in "picture_gallery[name]", with: "A new name"
                         }
        .updating
        .from(resource.attributes)
        .to({"name" => "A new name"}) # Example: .to({ 'name' => 'New name' })
    }

    # Delete
    it {
      expect(subject).to implement_delete_action(self)
        .for(resource)
        .reducing { resource_class.count }.by(1)
    }
  end

  describe "appending picture details" do
    let(:exisiting_picture_details) { create_list(:cmor_galleries_picture_detail, 2, picture_gallery: resource) }
    let(:resource) { create(:cmor_galleries_picture_gallery) }
    let(:base_path) { "/de/backend/bilder/picture_galleries" }
    let(:edit_path) { "#{base_path}/#{resource.to_param}/edit" }

    let(:submit_button) { within("form.edit_picture_gallery") { first('input[type="submit"]') } }

    before(:each) do
      exisiting_picture_details
      visit(edit_path)
      attach_file "picture_gallery[append_picture_detail_assets][]", [Cmor::Galleries::Engine.root.join(*%w[spec files cmor galleries picture_details example.png])]
    end

    it { expect { submit_button.click }.to change { resource.picture_details.count }.from(2).to(3) }
  end

  describe "replacing picture details" do
    let(:exisiting_picture_details) { create_list(:cmor_galleries_picture_detail, 2, picture_gallery: resource) }
    let(:resource) { create(:cmor_galleries_picture_gallery) }
    let(:base_path) { "/de/backend/bilder/picture_galleries" }
    let(:edit_path) { "#{base_path}/#{resource.to_param}/edit" }

    let(:submit_button) { within("form.edit_picture_gallery") { first('input[type="submit"]') } }

    before(:each) do
      exisiting_picture_details
      visit(edit_path)
      attach_file "picture_gallery[overwrite_picture_detail_assets][]", [Cmor::Galleries::Engine.root.join(*%w[spec files cmor galleries picture_details example.png])]
    end

    it { expect { submit_button.click }.to change { resource.picture_details.count }.from(2).to(1) }
  end
end
