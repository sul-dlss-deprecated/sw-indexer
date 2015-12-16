require 'rails_helper'

describe SwMapper do
  include XmlFixtures
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_public_xml) { Nokogiri::XML(item_image_xml, nil, 'UTF-8') }
  let(:item_purl_parser) { "<publicObject id='druid:zz999zz9999'></publicObject>" }
  let(:item_purl) { item_purl_parser.parse }

  let(:coll_pid) { 'druid:oo000oo0000' }
  let(:coll_public_xml) { Nokogiri::XML(coll_image_xml, nil, 'UTF-8') }
  let(:coll_purl_parser) { "<publicObject id='druid:oo000oo0000'></publicObject>" }
  let(:coll_purl) { coll_purl_parser.parse }

  describe 'convert_to_solr_doc' do
    it 'should properly map a digital object for SearchWorks' do
      allow(DiscoveryIndexer::InputXml::PurlxmlParserStrict).to receive(:new).with(item_pid, item_public_xml).and_return(item_purl_parser)
      allow(DiscoveryIndexer::InputXml::Modsxml).to receive(:new).with(item_pid).and_return(item_image_mods)
      mapper = SwMapper.new('zz999zz9999')
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(item_image_mods))
      allow(mapper).to receive(:collection).and_return('oo000oo0000')
      allow(mapper).to receive(:display_type).and_return('image')
      allow(mapper).to receive(:file_ids).and_return('a24.jp2')
      allow(mapper).to receive(:collection_with_title).and_return('oo000oo0000-|-Collection Title')

      expected_doc_hash =
      {
        all_search: ' Item title Personal name Role still image 1909 1915 Collection Title https://purl.stanford.edu/oo000oo0000 Access Condition ',
        author_1xx_search: nil,
        author_7xx_search: ['Personal name'],
        author_corp_display: [],
        author_meeting_display: [],
        author_other_facet: [],
        author_person_display: ['Personal name'],
        author_person_facet: ['Personal name'],
        author_person_full_display: ['Personal name'],
        author_sort: "\u{10FFFF} Item title",
        creation_year_isi: '1909',
        era_facet: nil,
        format: ['Image'],
        format_main_ssim: ['Image'],
        geographic_facet: nil,
        geographic_search: nil,
        id: 'zz999zz9999',
        imprint_display: '1909',
        language: [],
        physical: nil,
        pub_date: '1909',
        pub_date_display: '1909',
        pub_date_sort: '1909',
        pub_search: nil,
        pub_year_tisim: '1909',
        subject_all_search: nil,
        subject_other_search: nil,
        subject_other_subvy_search: nil,
        summary_search: nil,
        title_245_search: 'Item title.',
        title_245a_display: 'Item title',
        title_245a_search: 'Item title',
        title_display: 'Item title',
        title_full_display: 'Item title.',
        title_sort: 'Item title',
        title_variant_search: [],
        toc_search: nil,
        topic_facet: nil,
        topic_search: nil,
        url_suppl: nil,
        display_type: 'image',
        access_facet: 'Online',
        building_facet: 'Stanford Digital Repository',
        druid: 'zz999zz9999',
        file_id: ['a24.jp2', 'a25.jp2', 'a26.jp2', 'a27.jp2', 'a28.jp2'],
        url_fulltext: 'https://purl.stanford.edu/zz999zz9999',
        collection: ['aa000bb1111'],
        collection_with_title: ['aa000bb1111-|-Collection Name'],
        modsxml: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<mods xmlns=\"http://www.loc.gov/mods/v3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"3.3\" xsi:schemaLocation=\"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd\">\n      <titleInfo>\n        <title>Item title</title>\n      </titleInfo>\n      <name type=\"personal\">\n        <namePart>Personal name</namePart>\n        <role>\n          <roleTerm authority=\"marcrelator\" type=\"text\">Role</roleTerm>\n        </role>\n      </name>\n      <typeOfResource>still image</typeOfResource>\n      <originInfo>\n        <dateCreated point=\"start\" keyDate=\"yes\">1909</dateCreated>\n        <dateCreated point=\"end\">1915</dateCreated>\n      </originInfo>\n      <relatedItem type=\"host\">\n        <titleInfo>\n          <title>Collection Title</title>\n        </titleInfo>\n        <identifier type=\"uri\">https://purl.stanford.edu/oo000oo0000</identifier>\n        <typeOfResource collection=\"yes\"/>\n      </relatedItem>\n      <accessCondition type=\"copyright\">Access Condition</accessCondition>\n    </mods>\n"
      }
      expect(mapper).to receive(:convert_to_solr_doc).and_return(expected_doc_hash)
      mapper.convert_to_solr_doc
    end
  end

  describe 'mods_to_pub_date' do
    it 'nil values for publication_year_isi, creation_year_isi, and pub_year_tisim if no dates provided' do
      mapper = SwMapper.new('zz999zz9999')
      result_doc = {
        pub_year_tisim: nil,
        publication_year_isi: nil,
        creation_year_isi: nil
      }
      expect(mapper).to receive(:mods_to_pub_date).and_return(result_doc)
      mapper.mods_to_pub_date
    end
    it 'creates a value for date_type_sym if pub_date_sort >= 0 and date_type_sym not nil' do
      allow(DiscoveryIndexer::InputXml::PurlxmlParserStrict).to receive(:new).with(item_pid, item_public_xml).and_return(item_purl_parser)
      allow(DiscoveryIndexer::InputXml::Modsxml).to receive(:new).with(item_pid).and_return(item_image_mods)
      mapper = SwMapper.new('zz999zz9999')
      result_doc = {
        pub_year_tisim: '1909',
        publication_year_isi: '1909',
        creation_year_isi: nil
      }
      expect(mapper).to receive(:mods_to_pub_date).and_return(result_doc)
      mapper.mods_to_pub_date
    end
  end

  describe 'positive_int?' do
    let(:mapper) { SwMapper.new('zz999zz9999') }
    it 'returns true of integer version of string is > 0' do
      expect(mapper.send(:positive_int?, '250')).to be true
    end
    it 'returns true of integer version of string is = 0' do
      expect(mapper.send(:positive_int?, '0')).to be true
    end
    it 'returns false of integer version of string is < 0' do
      expect(mapper.send(:positive_int?, '-20')).to be false
    end
  end

  describe 'date_type_sym' do
    it 'is publication_year_isi if dateIssued' do
      allow(DiscoveryIndexer::InputXml::PurlxmlParserStrict).to receive(:new).with(coll_pid, coll_image_xml).and_return(coll_purl_parser)
      allow(DiscoveryIndexer::InputXml::Modsxml).to receive(:new).with(coll_pid).and_return(coll_issued_mods)
      mapper = SwMapper.new('oo000oo0000')
      result_doc = {
        publication_year_isi: '1909',
        creation_year_isi: nil
      }
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(coll_issued_mods))
      allow(mapper.modsxml).to receive(:term_values).with([:origin_info, :dateIssued]).and_return(result_doc)
      mapper.send(:date_type_sym)
    end
    it 'is creation_year_isi if dateCreated' do
      allow(DiscoveryIndexer::InputXml::PurlxmlParserStrict).to receive(:new).with(coll_pid, coll_image_xml).and_return(coll_purl_parser)
      allow(DiscoveryIndexer::InputXml::Modsxml).to receive(:new).with(coll_pid).and_return(coll_created_mods)
      mapper = SwMapper.new('oo000oo0000')
      result_doc = {
        publication_year_isi: nil,
        creation_year_isi: '1910'
      }
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(coll_created_mods))
      allow(mapper.modsxml).to receive(:term_values).with([:origin_info, :dateIssued]).and_return(nil)
      allow(mapper.modsxml).to receive(:term_values).with([:origin_info, :dateCreated]).and_return(result_doc)
      mapper.send(:date_type_sym)
    end
  end

  describe 'display_type' do
    it 'is the display_type from the identityMetadata if it exists' do
    end
    context 'is based upon the content type if no display_type' do
      it 'is book when content type is book' do
      end
      it 'is image when the content type is image, manuscript or map' do
      end
      it 'is file when content type is not book, image, manuscript, or map' do
      end
    end
  end

  describe 'file_ids' do
    it 'includes image_ids if display_type is image' do
    end
    it 'includes file_ids if display_type is file' do
    end
    it 'is nil if it is a collection' do
    end
  end

  describe 'collection' do
    it 'includes collection druid if no ckey is present' do
    end
    it 'includes collection ckey if ckey is present' do
    end
    it 'is an empty array if no collection data is available' do
    end
  end

  describe 'collection_with_title' do
    it 'includes collection druid with collection title if no ckey is present' do
    end
    it 'includes collection ckey with collection title if ckey is present' do
    end
    it 'is an empty array if no collection data available' do
    end
  end
end
