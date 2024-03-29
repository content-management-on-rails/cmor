require "rails_helper"

RSpec.describe Cmor::Cms::Page, type: :model do
  subject { create(:cmor_cms_page) }

  context "associations" do
    it { expect(subject).to have_many(:content_blocks) }
    it { expect(subject).to have_many(:navigation_items) }
  end

  context "callbacks" do
    subject { Cmor::Cms::Template.new }

    it "adds a '/' to the pathname before validation" do
      subject.pathname = "bar"
      subject.save
      expect(subject.pathname).to eq("bar/")
    end

    context "sets default handler on initialization" do
      it { expect(subject.handler).to eq(Cmor::Cms::Configuration.default_handlers[:page].to_s) }
    end

    context "sets default locale on initialization" do
      before(:each) { I18n.locale = :de }
      it { expect(subject.locale).to eq(I18n.locale.to_s) }
    end
  end

  context "page callbacks" do
    it "updates associated navigation items when the basename changes" do
      navigation_item = create(:cmor_cms_navigation_item, url: "/foo")
      page = build(:cmor_cms_page, pathname: "/", basename: "bar", locale: "de")
      page.navigation_items << navigation_item
      page.save!
      expect(navigation_item.url).to eq("/de/bar")
    end
  end

  context "validations" do
    it { expect(subject).to validate_presence_of :basename }
    # Removed test to respect adding a trailing slash to pathname before validation
    # if pathname is blank
    # it { expect(subject).to validate_presence_of :pathname }
    it { expect(subject).to validate_presence_of :title }
    it { expect(subject).to validate_uniqueness_of(:basename).scoped_to([:pathname, :locale, :format, :handler]) }

    it { expect(subject).to validate_inclusion_of(:format).in_array(Mime::SET.symbols.map(&:to_s)) }
    it { expect(subject).not_to allow_value("foo").for(:format) }

    it { expect(subject).to validate_inclusion_of(:handler).in_array(ActionView::Template::Handlers.extensions.map(&:to_s)) }
    it { expect(subject).not_to allow_value("foo").for(:handler) }

    it { expect(subject).to validate_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
    it { expect(subject).not_to allow_value("foo").for(:locale) }
  end

  context "#filename" do
    subject { Cmor::Cms::Page.new }

    it "builds foo.html from basename => foo, handler => html" do
      subject.basename = "foo"
      subject.locale = nil
      subject.handler = "html"

      expect(subject.filename).to eq("foo.html")
    end

    it "builds foo.en.html from basename => foo, locale => en, handler => html" do
      subject.basename = "foo"
      subject.locale = "en"
      subject.handler = "html"

      expect(subject.filename).to eq("foo.en.html")
    end
  end

  context "#home_page?" do
    subject { Cmor::Cms::Page.new }

    it "should return true if the pathname is '/' and the basename is 'home'" do
      subject.pathname = "/"
      subject.basename = "home"

      expect(subject.home_page?).to be(true)
    end

    it "should return false if the pathname is '/foo' and the basename is 'home'" do
      subject.pathname = "/foo"
      subject.basename = "home"

      expect(subject.home_page?).to be(false)
    end

    it "should return false if the pathname is '/' and the basename is 'foo'" do
      subject.pathname = "/"
      subject.basename = "foo"

      expect(subject.home_page?).to be(false)
    end
  end
end
