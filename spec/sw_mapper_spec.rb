require 'rails_helper'

describe SwMapper do
  include XmlFixtures

  before(:all) do
    item_pid = 'druid:zz999zz9999'
    @item_mods = Stanford::Mods::Record.new
    @item_mods.from_str(item_image_mods)
    item_public_xml = Nokogiri::XML(item_image_xml, nil, 'UTF-8')
    item_purl_parser = DiscoveryIndexer::InputXml::PurlxmlParserStrict.new(item_pid, item_public_xml)
    @item_purl = item_purl_parser.parse

    item_file_public_xml = Nokogiri::XML(item_file_xml, nil, 'UTF-8')
    item_file_purl_parser = DiscoveryIndexer::InputXml::PurlxmlParserStrict.new(item_pid, item_file_public_xml)
    @item_file_purl = item_file_purl_parser.parse

    @item_book_mods = Stanford::Mods::Record.new
    @item_book_mods.from_str(item_book_mods)
    item_book_public_xml = Nokogiri::XML(item_book_xml, nil, 'UTF-8')
    item_book_purl_parser = DiscoveryIndexer::InputXml::PurlxmlParserStrict.new('druid:cg160px5426', item_book_public_xml)
    @item_book_purl = item_book_purl_parser.parse

    coll_pid = 'druid:aa111bb1111'
    @coll_mods = Stanford::Mods::Record.new
    @coll_mods.from_str(coll_issued_mods)
    @coll_created_mods = Stanford::Mods::Record.new
    @coll_created_mods.from_str(coll_created_mods)
    @coll_not_issued_created_mods = Stanford::Mods::Record.new
    @coll_not_issued_created_mods.from_str(coll_not_issued_created_mods)
    @coll_neg_dates_mods = Stanford::Mods::Record.new
    @coll_neg_dates_mods.from_str(coll_neg_dates_mods)
    coll_public_xml = Nokogiri::XML(coll_image_xml, nil, 'UTF-8')
    coll_purl_parser = DiscoveryIndexer::InputXml::PurlxmlParserStrict.new(coll_pid, coll_public_xml)
    @coll_purl = coll_purl_parser.parse
  end

  describe 'convert_to_solr_doc' do
    it 'should properly map a digital object for SearchWorks' do
      @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)

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
      expect(mapper.convert_to_solr_doc).to eq(expected_doc_hash)
    end
  end

  describe 'mods_to_title_fields' do
    it 'creates a hash of title fields for the solr document' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      expect(mapper.mods_to_title_fields).to eq(title_245a_search: @coll_mods.sw_short_title,
                                                title_245_search: @coll_mods.sw_full_title,
                                                title_variant_search: @coll_mods.sw_addl_titles,
                                                title_sort: @coll_mods.sw_sort_title,
                                                title_245a_display: @coll_mods.sw_short_title,
                                                title_display: @coll_mods.sw_title_display,
                                                title_full_display: @coll_mods.sw_full_title)
    end
  end

  describe 'mods_to_author_fields' do
    it 'creates a hash of author fields for the solr document' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      expect(mapper.mods_to_author_fields).to eq(author_1xx_search: @coll_mods.sw_main_author,
                                                 author_7xx_search: @coll_mods.sw_addl_authors,
                                                 author_person_facet: @coll_mods.sw_person_authors,
                                                 author_other_facet: @coll_mods.sw_impersonal_authors,
                                                 author_sort: @coll_mods.sw_sort_author,
                                                 author_corp_display: @coll_mods.sw_corporate_authors,
                                                 author_meeting_display: @coll_mods.sw_meeting_authors,
                                                 author_person_display: @coll_mods.sw_person_authors,
                                                 author_person_full_display: @coll_mods.sw_person_authors)
    end
  end

  describe 'mods_to_subject_search_fields' do
    it 'creates a hash of subject search fields for the solr document' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      expect(mapper.mods_to_subject_search_fields).to eq(topic_search: @coll_mods.topic_search,
                                                         geographic_search: @coll_mods.geographic_search,
                                                         subject_other_search: @coll_mods.subject_other_search,
                                                         subject_other_subvy_search: @coll_mods.subject_other_subvy_search,
                                                         subject_all_search: @coll_mods.subject_all_search,
                                                         topic_facet: @coll_mods.topic_facet,
                                                         geographic_facet: @coll_mods.geographic_facet,
                                                         era_facet: @coll_mods.era_facet)
    end
  end

  describe 'mods_to_publication_fields' do
    it 'creates a hash of publication fields for the solr document' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      expect(mapper.mods_to_publication_fields).to eq(pub_search: @coll_mods.place,
                                                      pub_date_sort: @coll_mods.pub_date_sort,
                                                      imprint_display: @coll_mods.pub_date_display,
                                                      pub_date: @coll_mods.pub_date_facet,
                                                      pub_date_display: @coll_mods.pub_date_display)
    end
  end

  describe 'mods_to_pub_date' do
    it 'nil values for publication_year_isi, creation_year_isi, and pub_year_tisim if no dates provided' do
      mapper = SwMapper.new('zz999zz9999', @coll_not_issued_created_mods, @coll_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:pub_year_tisim]).to be_nil
      expect(result_doc[:publication_year_isi]).to be_nil
      expect(result_doc[:creation_year_isi]).to be_nil
    end
    it 'creates a value for date_type_sym if pub_date_sort >= 0 and date_type_sym not nil' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:pub_year_tisim]).to eq(@coll_mods.pub_date_sort)
      expect(result_doc[:publication_year_isi]).to eq('1909')
      expect(result_doc[:creation_year_isi]).to be_nil
    end
  end

  describe 'mods_to_others' do
    it 'creates a hash of miscellaneous values for the solr document' do
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      expect(mapper.mods_to_others).to eq(format_main_ssim: @coll_mods.format_main,
                                          format: @coll_mods.format,
                                          language: @coll_mods.sw_language_facet,
                                          physical: @coll_mods.term_values([:physical_description, :extent]),
                                          summary_search: @coll_mods.term_values(:abstract),
                                          toc_search: @coll_mods.term_values(:tableOfContents),
                                          url_suppl: @coll_mods.term_values([:related_item, :location, :url]))
    end
  end

  describe 'hard_coded_fields' do
    it 'creates a hash of hard-coded values for the solr document' do
      druid = 'zz999zz9999'
      mapper = SwMapper.new(druid, @coll_mods, @coll_purl)
      expect(mapper.hard_coded_fields).to eq(url_fulltext: "https://purl.stanford.edu/#{druid}", access_facet: 'Online', building_facet: 'Stanford Digital Repository')
    end
  end

  describe 'positive_int?' do
    let(:mapper) { SwMapper.new('zz999zz9999', @coll_mods, @coll_purl) }
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
      mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:publication_year_isi]).to eq('1909')
      expect(result_doc[:creation_year_isi]).to be_nil
    end
    it 'is creation_year_isi if dateCreated' do
      mapper = SwMapper.new('zz999zz9999', @coll_created_mods, @coll_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:creation_year_isi]).to eq('1910')
      expect(result_doc[:publication_year_isi]).to be_nil
    end
  end

  describe 'display_type' do
    it 'is the display_type from the identityMetadata if it exists' do
      @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_file_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:display_type]).to eq('file')
    end
    context 'is based upon the content type if no display_type' do
      it 'is book when content type is book' do
        @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
        mapper = SwMapper.new('zz999zz9999', @item_book_mods, @item_book_purl, @collection_data)
        result_doc = mapper.convert_to_solr_doc
        expect(result_doc[:display_type]).to eq('book')
      end
      it 'is image when the content type is image, manuscript or map' do
        mapper = SwMapper.new('zz999zz9999', @coll_mods, @coll_purl)
        result_doc = mapper.convert_to_solr_doc
        expect(result_doc[:display_type]).to eq('image')
      end
      it 'is file when content type is not book, image, manuscript, or map' do
      end
    end
  end

  describe 'file_ids' do
    it 'includes image_ids if display_type is image' do
      mapper = SwMapper.new('cg160px5426', @item_book_mods, @item_book_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:file_id]).to eq(['cg160px5426_00_0001.jp2', 'cg160px5426_00_0002.jp2', 'cg160px5426_00_0003.jp2', 'cg160px5426_00_0004.jp2', 'cg160px5426_00_0005.jp2'])
    end
    it 'includes file_ids if display_type is file' do
      @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_file_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:file_id]).to eq(['a24.jp2', 'a25.jp2', 'a26.jp2', 'a27.jp2', 'a28.jp2'])
    end
    it 'is nil if it is a collection' do
      mapper = SwMapper.new('aa111bb1111', @coll_mods, @coll_purl)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:file_id]).to be_nil
    end
  end

  describe 'collection' do
    it 'includes collection druid if no ckey is present' do
      @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection]).to eq(['aa000bb1111'])
    end
    it 'includes collection ckey if ckey is present' do
      @collection_data = { 'oo000oo0000' => { label: 'Collection Name', ckey: '12345678' } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection]).to eq(['12345678'])
    end
    it 'is an empty array if no collection data is available' do
      @collection_data = {}
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection]).to eq([])
    end
  end

  describe 'collection_with_title' do
    it 'includes collection druid with collection title if no ckey is present' do
      @collection_data = { 'aa000bb1111' => { label: 'Collection Name', catkey: nil } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection_with_title]).to eq(['aa000bb1111-|-Collection Name'])
    end
    it 'includes collection ckey with collection title if ckey is present' do
      @collection_data = { 'oo000oo0000' => { label: 'Collection Name', ckey: '12345678' } }
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection_with_title]).to eq(['12345678-|-Collection Name'])
    end
    it 'is an empty array if no collection data available' do
      @collection_data = {}
      mapper = SwMapper.new('zz999zz9999', @item_mods, @item_purl, @collection_data)
      result_doc = mapper.convert_to_solr_doc
      expect(result_doc[:collection_with_title]).to eq([])
    end
  end
end
