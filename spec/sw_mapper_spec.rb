require 'rails_helper'

describe SwMapper do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:item_purl_xml) { "<publicObject id='druid:zz999zz9999'></publicObject>" }
  let(:coll_pid) { 'druid:oo000oo0000' }
  let(:coll_purl_xml) { "<publicObject id='druid:oo000oo0000'></publicObject>" }

  describe 'convert_to_solr_doc' do
    it 'should properly map a digital object for SearchWorks' do
      allow(DiscoveryIndexer::InputXml::PurlxmlParserStrict).to receive(:new).with(item_pid, item_image_xml).and_return(item_purl_xml)
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
        era_facet: nil,
        format: ['Image'],
        format_main_ssim: ['Image'],
        geographic_facet: nil,
        geographic_search: nil,
        id: 'zz999zz9999',
        language: [],
        physical: nil,
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

  describe '#mods_to_publication_fields' do
    let(:mapper) { SwMapper.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it ':pub_year_isi from Stanford::Mods::Record.pub_year_int' do
      expect(smods_rec).to receive(:pub_year_int).and_return(1666)
      expect(mapper.mods_to_publication_fields[:pub_year_isi]).to eq 1666
    end
    it ':pub_date_display from Stanford::Mods::Record.pub_date_facet_single_value' do
      expect(smods_rec).to receive(:pub_date_facet_single_value).and_return('18th century')
      expect(mapper.mods_to_publication_fields[:pub_date_display]).to eq '18th century'
    end
    it ':pub_year_tisim' do
      expect(smods_rec).to receive(:pub_year_int).and_return(666)
      expect(mapper.mods_to_publication_fields[:pub_year_tisim]).to eq 666
    end
    context ':creation_year_isi' do
      it 'year from dateCreated element' do
        expect(smods_rec).to receive(:date_created_elements).at_least(1).times.and_return([])
        expect(smods_rec).to receive(:year_int).with([]).at_least(1).times.and_return(898)
        expect(mapper.mods_to_publication_fields[:creation_year_isi]).to eq 898
      end
      it 'nil if no dateCreated elements' do
        expect(mapper.mods_to_publication_fields[:creation_year_isi]).to eq nil
      end
    end
    context ':publication_year_isi' do
      it 'year from dateIssued element' do
        expect(smods_rec).to receive(:date_issued_elements).at_least(1).times.and_return([])
        expect(smods_rec).to receive(:year_int).with([]).at_least(1).times.and_return(42)
        expect(mapper.mods_to_publication_fields[:publication_year_isi]).to eq 42
      end
      it 'nil if no dateIssued elements' do
        expect(mapper.mods_to_publication_fields[:publication_year_isi]).to eq nil
      end
    end
    it ':pub_search' do
      expect(smods_rec).to receive(:place).and_return('need pub_search impl in stanford-mods')
      expect(mapper.mods_to_publication_fields[:pub_search]).to eq 'need pub_search impl in stanford-mods'
    end
    it ':imprint_display' do
      expect(smods_rec).to receive(:pub_date_display).and_return('need imprint_display impl in stanford-mods')
      expect(mapper.mods_to_publication_fields[:imprint_display]).to eq 'need imprint_display impl in stanford-mods'
    end

    # :pub_date_sort (deprecated Solr field)
    # :pub_date (deprecated Solr field)
  end

  describe '#date_slider_vals_for_pub_year' do
    let(:mapper) { SwMapper.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(coll_created_mods))
    end
    it 'nil if no dates provided' do
      allow(mapper.modsxml).to receive(:pub_year_int).and_return(nil)
      expect(mapper.date_slider_vals_for_pub_year).to be nil
    end
    it 'value if there is a pub year' do
      allow(mapper.modsxml).to receive(:pub_year_int).and_return(2016)
      expect(mapper.date_slider_vals_for_pub_year).to be 2016
    end
    it 'nil if value is negative' do
      allow(mapper.modsxml).to receive(:pub_year_int).and_return(-5)
      expect(mapper.date_slider_vals_for_pub_year).to be nil
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
