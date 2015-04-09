require 'rails_helper'

describe SwMapper do

  context "No catkey" do
	it "should properly map a digital object for SearchWorks" do
	  setup('zz999zz9999','item_mods.xml','item_public.xml')

	  expected_doc_hash =
        {
           :all_search => " Item title Personal name Role still image 1909 1915 Collection Title http://purl.stanford.edu/oo000oo0000 Access Condition ",
           :author_1xx_search => nil,
           :author_7xx_search => ["Personal name"],
           :author_corp_display => [],
           :author_meeting_display => [],
	       :author_other_facet => [],
	       :author_person_display => ["Personal name"],
	       :author_person_facet => ["Personal name"],
	       :author_person_full_display => ["Personal name"],
	       :author_sort => " Item title",
	       :creation_year_isi => "1909",
	       :era_facet => nil,
	       :format => ["Image"],
	       :format_main_ssim => ["Image"],
	       :geographic_facet => nil,
	       :geographic_search => nil,
	       :id => "zz999zz9999",
	       :imprint_display => "1909",
	       :language => [],
	       :physical => nil,
	       :pub_date => "1909",
	       :pub_date_display => "1909",
	       :pub_date_sort => "1909",
	       :pub_search => nil,
	       :pub_year_tisim => "1909",
	       :subject_all_search => nil,
	       :subject_other_search => nil,
	       :subject_other_subvy_search => nil,
	       :summary_search => nil,
	       :title_245_search => "Item title.",
	       :title_245a_display => "Item title",
	       :title_245a_search => "Item title",
	       :title_display => "Item title",
	       :title_full_display => "Item title.",
	       :title_sort => "Item title",
	       :title_variant_search => [],
	       :toc_search => nil,
	       :topic_facet => nil,
	       :topic_search => nil,
	       :url_suppl => nil,
	       :display_type => "image",
	       :access_facet => "Online",
	       :building_facet => "Stanford Digital Repository",
	       :druid => "zz999zz9999",
	       :file_id => ["a24.jp2", "a25.jp2", "a26.jp2", "a27.jp2", "a28.jp2"],
	       :url_fulltext => "http://purl.stanford.edu/zz999zz9999",
	       :collection => ["oo000oo0000"],
	       :collection_with_title => ["oo000oo0000-|-Collection Name"],
	       :modsxml => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<mods xmlns=\"http://www.loc.gov/mods/v3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"3.3\" xsi:schemaLocation=\"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd\">\n  <titleInfo>\n    <title>Item title</title>\n  </titleInfo>\n  <name type=\"personal\">\n    <namePart>Personal name</namePart>\n    <role>\n      <roleTerm authority=\"marcrelator\" type=\"text\">Role</roleTerm>\n    </role>\n  </name>\n  <typeOfResource>still image</typeOfResource>\n  <originInfo>\n    <dateCreated point=\"start\" keyDate=\"yes\">1909</dateCreated>\n    <dateCreated point=\"end\">1915</dateCreated>\n  </originInfo>\n  <relatedItem type=\"host\">\n    <titleInfo>\n      <title>Collection Title</title>\n    </titleInfo>\n    <identifier type=\"uri\">http://purl.stanford.edu/oo000oo0000</identifier>\n    <typeOfResource collection=\"yes\"/>\n  </relatedItem>\n  <accessCondition type=\"copyright\">Access Condition</accessCondition>\n</mods>\n"
        }

      expect(@mapper.convert_to_solr_doc).to eq(expected_doc_hash)
	end
  end
end
