require 'rails_helper'

describe SwMapper do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }

  describe '#convert_to_solr_doc' do
    it 'correctly maps MODS digital object to Solr doc hash' do
      smods_rec.from_nk_node(Nokogiri::XML(item_image_mods))
      purl_parser=DiscoveryIndexer::InputXml::PurlxmlParserStrict.new(item_pid,Nokogiri::XML(item_image_xml))
      purl=purl_parser.parse()
      collection_names ||= {'oo000oo0000'=>{:label=>'Test Collection Name',:catkey=>'000001'}}
      collection_data=collection_names.map do |k,v|
        col=DiscoveryIndexer::Collection.new(k)
        allow(col).to receive(:title).and_return v[:label]
        allow(col).to receive(:searchworks_id).and_return k
        col
      end
      mapper = described_class.new(item_pid)
      allow(mapper).to receive(:collection_data).and_return(collection_data)
      allow(mapper).to receive(:modsxml).and_return(smods_rec)
      allow(mapper).to receive(:purlxml).and_return(purl)

      expected_doc_hash =        
        { id: item_pid, 
          druid: item_pid, 
          title_245a_search: "Item title", 
          title_245_search:  "Item title.",
          title_variant_search: [],
          title_sort: "Item title",
          title_245a_display: "Item title",
          title_display: "Item title", 
          title_full_display: "Item title.", 
          author_1xx_search: nil, 
          author_7xx_search: ["Personal name"], 
          author_person_facet: ["Personal name"],
          author_other_facet: [],
          author_sort: "\u{10FFFF} Item title",
          author_corp_display: [],
          author_meeting_display: [],
          author_person_display: ["Personal name"],
          author_person_full_display: ["Personal name"],
          topic_search: nil, 
          geographic_search: nil,
          subject_other_search: nil,
          subject_other_subvy_search: nil, 
          subject_all_search: nil, 
          topic_facet: nil, 
          geographic_facet: nil, 
          era_facet: nil, 
          pub_search: nil, 
          pub_year_isi: 1909, 
          pub_date_sort: "1909",
          imprint_display: "1909 - 1915",
          pub_date: "1909",
          pub_year_ss: "1909",
          pub_year_tisim: 1909,
          creation_year_isi: 1909,
          publication_year_isi: nil,
          format_main_ssim: ["Image"],
          format: ["Image"],
          genre_ssim: [], 
          language: [],
          physical: nil,
          summary_search: nil, 
          toc_search: nil,
          url_suppl: nil,
          url_fulltext: "https://purl.stanford.edu/druid:zz999zz9999",
          access_facet: "Online",
          building_facet: "Stanford Digital Repository",
          file_id: "druid:zz999zz9999%2Fa24.jp2",
          collection: ["oo000oo0000"],
          collection_with_title: ["oo000oo0000-|-Test Collection Name"], 
          set: [], 
          set_with_title: [], 
          modsxml: "<?xml version=\"1.0\"?>\n<mods xmlns=\"http://www.loc.gov/mods/v3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"3.3\" xsi:schemaLocation=\"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd\">\n      <titleInfo>\n        <title>Item title</title>\n      </titleInfo>\n      <name type=\"personal\">\n        <namePart>Personal name</namePart>\n        <role>\n          <roleTerm authority=\"marcrelator\" type=\"text\">Role</roleTerm>\n        </role>\n      </name>\n      <typeOfResource>still image</typeOfResource>\n      <originInfo>\n        <dateCreated point=\"start\" keyDate=\"yes\">1909</dateCreated>\n        <dateCreated point=\"end\">1915</dateCreated>\n      </originInfo>\n      <relatedItem type=\"host\">\n        <titleInfo>\n          <title>Collection Title</title>\n        </titleInfo>\n        <identifier type=\"uri\">https://purl.stanford.edu/oo000oo0000</identifier>\n        <typeOfResource collection=\"yes\"/>\n      </relatedItem>\n      <accessCondition type=\"copyright\">Access Condition</accessCondition>\n    </mods>\n", :all_search=>" Item title Personal name Role still image 1909 1915 Collection Title https://purl.stanford.edu/oo000oo0000 Access Condition "
        }
      expect(mapper.convert_to_solr_doc).to eq expected_doc_hash
    end
  end

  describe '#blank_title_returns_untitled' do
    let(:fake_druid) { 'oo000oo0000' }
    let(:mapper) { described_class.new(fake_druid) }
    let(:smods_rec) { Stanford::Mods::Record.new }
    it 'uses "Untitled" for the title if the title node is totally missing from MODS' do
      mods=<<-EOF
        <mods xmlns="#{Mods::MODS_NS}">
          <nothingHere/>
        </mods>
        EOF
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(mods))
      mapped_sw_title_fields=mapper.mods_to_title_fields
      [:title_245a_search,:title_245_search,:title_variant_search,:title_sort,:title_245a_display,:title_display,:title_full_display].each do |title_field|
        expect(mapped_sw_title_fields[title_field]).to eq '[Untitled]'
      end
    end
    it 'uses "Untitled" for the title if the title is set to a blank string in the MODS' do
      mods=<<-EOF
        <mods xmlns="#{Mods::MODS_NS}">
          <titleInfo>
            <title></title>
          </titleInfo>
        </mods>
        EOF
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(mods))
      mapped_sw_title_fields=mapper.mods_to_title_fields
      [:title_245a_search,:title_245_search,:title_variant_search,:title_sort,:title_245a_display,:title_display,:title_full_display].each do |title_field|
        expect(mapped_sw_title_fields[title_field]).to eq '[Untitled]'
      end
    end
  end
  
  describe '#mods_to_title_fields' do
    let(:mapper) { described_class.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
      allow(smods_rec).to receive(:full_titles).and_return(['something not blank'])
      allow(smods_rec).to receive(:sw_addl_titles).and_return(['something not blank'])
    end
    it 'returns a hash' do
      expect(mapper.mods_to_title_fields).to be_an_instance_of(Hash)
    end
    it ':title_245a_search from Stanford::Mods::Record.sw_short_title' do
      expect(smods_rec).to receive(:sw_short_title).and_return('short title')
      expect(mapper.mods_to_title_fields[:title_245a_search]).to eq 'short title'
    end
    it ':title_245_search from Stanford::Mods::Record.sw_full_title' do
      expect(smods_rec).to receive(:sw_full_title).at_least(1).times.and_return('full title')
      expect(mapper.mods_to_title_fields[:title_245_search]).to eq 'full title'
    end
    it ':title_variant_search from Stanford::Mods::Record.sw_addl_titles' do
      expect(smods_rec).to receive(:sw_addl_titles).and_return(['addl titles', 'foo'])
      expect(mapper.mods_to_title_fields[:title_variant_search]).to eq ['addl titles', 'foo']
    end
    it ':title_sort from Stanford::Mods::Record.sw_sort_title' do
      expect(smods_rec).to receive(:sw_sort_title).and_return('sort title')
      expect(mapper.mods_to_title_fields[:title_sort]).to eq 'sort title'
    end
    it ':title_245a_display from Stanford::Mods::Record.sw_short_title' do
      expect(smods_rec).to receive(:sw_short_title).and_return('short title again')
      expect(mapper.mods_to_title_fields[:title_245a_search]).to eq 'short title again'
    end
    it ':title_display from Stanford::Mods::Record.sw_title_display' do
      expect(smods_rec).to receive(:sw_title_display).and_return('display title')
      expect(mapper.mods_to_title_fields[:title_display]).to eq 'display title'
    end
    it ':title_full_display from Stanford::Mods::Record.sw_full_title' do
      expect(smods_rec).to receive(:sw_full_title).at_least(1).times.and_return('full title again')
      expect(mapper.mods_to_title_fields[:title_245_search]).to eq 'full title again'
    end
  end

  describe '#mods_to_author_fields' do
    let(:mapper) { described_class.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it 'returns a hash' do
      expect(mapper.mods_to_author_fields).to be_an_instance_of(Hash)
    end
    it ':author_1xx_search from Stanford::Mods::Record.sw_main_author' do
      expect(smods_rec).to receive(:sw_main_author).and_return('main author')
      expect(mapper.mods_to_author_fields[:author_1xx_search]).to eq 'main author'
    end
    it ':author_7xx_search from Stanford::Mods::Record.sw_addl_authors' do
      expect(smods_rec).to receive(:sw_addl_authors).and_return(['author 1', 'author 2'])
      expect(mapper.mods_to_author_fields[:author_7xx_search]).to eq ['author 1', 'author 2']
    end
    it ':author_person_facet from Stanford::Mods::Record.sw_person_authors' do
      expect(smods_rec).to receive(:sw_person_authors).and_return(['author 3', 'author 4'])
      expect(mapper.mods_to_author_fields[:author_person_facet]).to eq ['author 3', 'author 4']
    end
    it ':author_other_facet from Stanford::Mods::Record.sw_impersonal_authors' do
      expect(smods_rec).to receive(:sw_impersonal_authors).and_return(['author 5', 'author 6'])
      expect(mapper.mods_to_author_fields[:author_other_facet]).to eq ['author 5', 'author 6']
    end
    it ':author_sort from Stanford::Mods::Record.sw_sort_author' do
      expect(smods_rec).to receive(:sw_sort_author).and_return('sort author')
      expect(mapper.mods_to_author_fields[:author_sort]).to eq 'sort author'
    end
    it ':author_corp_display from Stanford::Mods::Record.sw_corporate_authors' do
      expect(smods_rec).to receive(:sw_corporate_authors).and_return('main author')
      expect(mapper.mods_to_author_fields[:author_corp_display]).to eq 'main author'
    end
    it ':author_meeting_display from Stanford::Mods::Record.sw_meeting_authors' do
      expect(smods_rec).to receive(:sw_meeting_authors).and_return(['author 9', 'author 10'])
      expect(mapper.mods_to_author_fields[:author_meeting_display]).to eq ['author 9', 'author 10']
    end
    it ':author_person_display from Stanford::Mods::Record.sw_person_authors' do
      expect(smods_rec).to receive(:sw_person_authors).and_return(['author 11', 'author 12'])
      expect(mapper.mods_to_author_fields[:author_person_display]).to eq ['author 11', 'author 12']
    end
    it ':author_person_full_display from Stanford::Mods::Record.sw_person_authors' do
      expect(smods_rec).to receive(:sw_person_authors).and_return(['author 13', 'author 14'])
      expect(mapper.mods_to_author_fields[:author_person_full_display]).to eq ['author 13', 'author 14']
    end
  end

  describe '#mods_to_subject_fields' do
    let(:mapper) { described_class.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it 'returns a hash' do
      expect(mapper.mods_to_subject_fields).to be_an_instance_of(Hash)
    end
    it ':topic_search from Stanford::Mods::Record.topic_search' do
      expect(smods_rec).to receive(:topic_search).at_least(1).times.and_return(['topic 1', 'topic 2'])
      expect(mapper.mods_to_subject_fields[:topic_search]).to eq ['topic 1', 'topic 2']
    end
    it ':geographic_search from Stanford::Mods::Record.geographic_search' do
      expect(smods_rec).to receive(:geographic_search).at_least(1).times.and_return(['geo topic 1', 'geo topic 2'])
      expect(mapper.mods_to_subject_fields[:geographic_search]).to eq ['geo topic 1', 'geo topic 2']
    end
    it ':subject_other_search from Stanford::Mods::Record.subject_other_search' do
      expect(smods_rec).to receive(:subject_other_search).at_least(1).times.and_return(['other 1', 'other 2'])
      expect(mapper.mods_to_subject_fields[:subject_other_search]).to eq ['other 1', 'other 2']
    end
    it ':subject_other_subvy_search from Stanford::Mods::Record.subject_other_subvy_search' do
      expect(smods_rec).to receive(:subject_other_subvy_search).at_least(1).times.and_return(['other 3', 'other 4'])
      expect(mapper.mods_to_subject_fields[:subject_other_subvy_search]).to eq ['other 3', 'other 4']
    end
    it ':subject_all_search from Stanford::Mods::Record.subject_all_search' do
      expect(smods_rec).to receive(:subject_all_search).and_return(['sub 1', 'sub 2'])
      expect(mapper.mods_to_subject_fields[:subject_all_search]).to eq ['sub 1', 'sub 2']
    end
    it ':topic_facet from Stanford::Mods::Record.topic_facet' do
      expect(smods_rec).to receive(:topic_facet).and_return(['topicf 1', 'topicf 2'])
      expect(mapper.mods_to_subject_fields[:topic_facet]).to eq ['topicf 1', 'topicf 2']
    end
    it ':geographic_facet from Stanford::Mods::Record.geographic_facet' do
      expect(smods_rec).to receive(:geographic_facet).and_return(['geo 1', 'geo 2'])
      expect(mapper.mods_to_subject_fields[:geographic_facet]).to eq ['geo 1', 'geo 2']
    end
    it ':era_facet from Stanford::Mods::Record.era_facet' do
      expect(smods_rec).to receive(:era_facet).and_return(['era 1', 'era 2'])
      expect(mapper.mods_to_subject_fields[:era_facet]).to eq ['era 1', 'era 2']
    end
  end

  describe '#mods_to_publication_fields' do
    let(:mapper) { described_class.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it 'returns a hash' do
      expect(mapper.mods_to_publication_fields).to be_an_instance_of(Hash)
    end
    it ':pub_date_sort (deprecated) from Stanford::Mods::record.pub_year_sort_str' do
      expect(smods_rec).to receive(:pub_year_sort_str).and_return('1777')
      expect(mapper.mods_to_publication_fields[:pub_date_sort]).to eq '1777'
    end
    it ':pub_year_isi from Stanford::Mods::Record.pub_year_int' do
      expect(smods_rec).to receive(:pub_year_int).and_return(1666)
      expect(mapper.mods_to_publication_fields[:pub_year_isi]).to eq 1666
    end
    it ':pub_date (deprecated) from Stanford::Mods::Record.pub_date_facet_single_value' do
      expect(smods_rec).to receive(:pub_year_display_str).and_return('6 B.C.')
      expect(mapper.mods_to_publication_fields[:pub_date]).to eq '6 B.C.'
    end
    it ':pub_year_ss from Stanford::Mods::Record.pub_year_display_str' do
      expect(smods_rec).to receive(:pub_year_display_str).and_return('18th century')
      expect(mapper.mods_to_publication_fields[:pub_year_ss]).to eq '18th century'
    end
    it ':pub_year_tisim' do
      expect(smods_rec).to receive(:pub_year_int).and_return('need pub_year_mult impl in stanford-mods')
      expect(mapper.mods_to_publication_fields[:pub_year_tisim]).to eq 'need pub_year_mult impl in stanford-mods'
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
      expect(smods_rec).to receive(:imprint_display_str).and_return('imprint_display_str from stanford-mods')
      expect(mapper.mods_to_publication_fields[:imprint_display]).to eq 'imprint_display_str from stanford-mods'
    end
  end

  describe '#mods_to_others' do
    let(:mapper) { described_class.new('oo000oo0000') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it 'returns a hash' do
      expect(mapper.mods_to_others).to be_an_instance_of(Hash)
    end
    it ':format_main_ssim from Stanford::Mods::Record.format_main' do
      expect(smods_rec).to receive(:format_main).and_return(['format 1', 'format 2'])
      expect(mapper.mods_to_others[:format_main_ssim]).to eq ['format 1', 'format 2']
    end
    it ':format from Stanford::Mods::Record.format' do
      expect(smods_rec).to receive(:format).and_return('format deprecated')
      expect(mapper.mods_to_others[:format]).to eq 'format deprecated'
    end
    it ':language from Stanford::Mods::Record.sw_language_facet' do
      expect(smods_rec).to receive(:sw_language_facet).and_return(['lang 1', 'lang 2'])
      expect(mapper.mods_to_others[:language]).to eq ['lang 1', 'lang 2']
    end
    it ':physical from Stanford::Mods::Record.term_values([:physical_description, :extent])' do
      expect(smods_rec).to receive(:term_values).with([:physical_description, :extent]).and_return('extent')
      allow(smods_rec).to receive(:term_values)
      expect(mapper.mods_to_others[:physical]).to eq 'extent'
    end
    it ':summary_search from Stanford::Mods::Record.term_values(:abstract)' do
      expect(smods_rec).to receive(:term_values).with(:abstract).and_return('abstract')
      allow(smods_rec).to receive(:term_values)
      expect(mapper.mods_to_others[:summary_search]).to eq 'abstract'
    end
    it ':toc_search from Stanford::Mods::Record.term_values(:tableOfContents)' do
      expect(smods_rec).to receive(:term_values).with(:tableOfContents).and_return('tableOfContents')
      allow(smods_rec).to receive(:term_values)
      expect(mapper.mods_to_others[:toc_search]).to eq 'tableOfContents'
    end
    it ':url_suppl from Stanford::Mods::Record.term_values([:related_item, :location, :url])' do
      expect(smods_rec).to receive(:term_values).with([:related_item, :location, :url]).and_return(['url suppl 1', 'url suppl 2'])
      allow(smods_rec).to receive(:term_values)
      expect(mapper.mods_to_others[:url_suppl]).to eq ['url suppl 1', 'url suppl 2']
    end
    it ':genre_ssim from Stanford::Mods::Record.sw_genre' do
      expect(smods_rec).to receive(:sw_genre).and_return(['genre 1', 'genre 2'])
      expect(mapper.mods_to_others[:genre_ssim]).to eq ['genre 1', 'genre 2']
    end
  end

  describe '#public_xml_to_fields' do
    let(:mapper) { described_class.new('oo000oo0000') }
    let(:public_xml_data_model) { double('DiscoveryIndexer::InputXml::PurlxmlModel').as_null_object }
    before(:example) do
      allow(mapper).to receive(:purlxml).and_return(public_xml_data_model)
    end
    it 'returns a Hash' do
      expect(mapper.public_xml_to_fields).to be_an_instance_of(Hash)
    end
    it ':file_id from #file_ids' do
      expect(mapper).to receive(:file_ids).and_return(['file1', 'file2'])
      expect(mapper.public_xml_to_fields[:file_id]).to eq ['file1', 'file2']
    end
    it ':collection from #collection_ids' do
      expect(mapper).to receive(:collection_ids).and_return(['coll_id1', 'coll_id2'])
      expect(mapper.public_xml_to_fields[:collection]).to eq ['coll_id1', 'coll_id2']
    end
    it ':collection_with_title from #collection_with_title' do
      expect(mapper).to receive(:collection_with_title).and_return(['coll_id1-|-coll_title1', 'coll_id2-|-coll_title2'])
      expect(mapper.public_xml_to_fields[:collection_with_title]).to eq ['coll_id1-|-coll_title1', 'coll_id2-|-coll_title2']
    end
    it ':set from #constituent_ids' do
      expect(mapper).to receive(:constituent_ids).and_return(['stit_id1', 'stit_id2'])
      expect(mapper.public_xml_to_fields[:set]).to eq ['stit_id1', 'stit_id2']
    end
    it ':set_with_title from #constituent_with_title' do
      expect(mapper).to receive(:constituent_with_title).and_return(['stit_id1-|-stit_title1', 'stit_id2-|-stit_title2'])
      expect(mapper.public_xml_to_fields[:set_with_title]).to eq ['stit_id1-|-stit_title1', 'stit_id2-|-stit_title2']
    end
  end

  describe '#hard_coded_fields' do
    let(:mapper) { described_class.new('oa123ei4567') }
    before(:example) do
      allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str('<mods/>'))
    end
    it 'returns a hash' do
      expect(mapper.hard_coded_fields).to be_an_instance_of(Hash)
    end
    it ':url_fulltext' do
      expect(mapper.hard_coded_fields[:url_fulltext]).to eq "https://purl.stanford.edu/oa123ei4567"
    end
    it ':access_facet' do
      expect(mapper.hard_coded_fields[:access_facet]).to eq 'Online'
    end
    it 'building_facet' do
      expect(mapper.hard_coded_fields[:building_facet]).to eq 'Stanford Digital Repository'
    end
  end

  context 'pub date slider field support methods' do
    describe '#date_slider_vals_for_pub_year' do
      let(:mapper) { described_class.new('oo000oo0000') }
      before(:example) do
        allow(mapper).to receive(:modsxml).and_return(smods_rec.from_str(coll_created_mods))
      end
      it 'nil if no dates provided' do
        allow(mapper.modsxml).to receive(:pub_year_int).and_return(nil)
        expect(mapper.send(:date_slider_vals_for_pub_year)).to be nil
      end
      it 'value if there is a pub year' do
        allow(mapper.modsxml).to receive(:pub_year_int).and_return(2016)
        expect(mapper.send(:date_slider_vals_for_pub_year)).to be 2016
      end
      it 'nil if value is negative' do
        allow(mapper.modsxml).to receive(:pub_year_int).and_return(-5)
        expect(mapper.send(:date_slider_vals_for_pub_year)).to be nil
      end
    end

    describe '#positive_int?' do
      let(:mapper) { described_class.new('zz999zz9999') }
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
  end

  describe '#file_ids' do
    let(:fake_druid) { 'zz999zz9999' }
    let(:purl_xml_model) { DiscoveryIndexer::InputXml::PurlxmlModel.new }
    let(:mapper) { described_class.new(fake_druid) }
    it 'is populated with the first image_id only if dor_content_type is book, image, manuscript, map, or webarchive-seed' do
      allow(purl_xml_model).to receive(:is_collection).and_return(false)
      allow(purl_xml_model).to receive(:sw_image_ids).and_return(['zz999zz9999%2Fa24.jp2', 'zz999zz9999%2Fthumb.jp2'])
      allow(mapper).to receive(:purlxml).and_return(purl_xml_model)
      %w(book image manuscript map webarchive-seed).each { |type|
        allow(purl_xml_model).to receive(:dor_content_type).and_return(type)
        expect(mapper.send(:file_ids)).to eq 'zz999zz9999%2Fa24.jp2'
      }
    end
    it 'is nil if it is a collection' do
      allow(purl_xml_model).to receive(:is_collection).and_return(true)
      allow(mapper).to receive(:purlxml).and_return(purl_xml_model)
      expect(mapper.send(:file_ids)).to eq nil
    end
    it 'is nil if dor_content_type is not book, image, manuscript, map, or webarchive-seed' do
      allow(purl_xml_model).to receive(:is_collection).and_return(false)
      allow(purl_xml_model).to receive(:dor_content_type).and_return('file')
      allow(mapper).to receive(:purlxml).and_return(purl_xml_model)
      expect(mapper.send(:file_ids)).to eq nil
    end
  end

  describe 'collection data support methods' do
    let(:fake_druid) { 'oo000oo0000' }
    let(:mapper) { described_class.new(fake_druid) }
    let(:coll_data1) { double('discovery-indexer-collection1', searchworks_id: 'coll1_id', title: 'coll1_title') }
    let(:coll_data2) { double('discovery-indexer-collection2', searchworks_id: 'coll2_id', title: 'coll2_title') }
    describe '#collection_ids' do
      it 'gets them from DiscoveryIndexer::GeneralMapper.collection_data.searchworks_id' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:collection_data).and_return([coll_data1, coll_data2])
        expect(mapper.send(:collection_ids)).to eq ['coll1_id', 'coll2_id']
      end
      it 'is an empty array if no collection data is available' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:collection_data).and_return([])
        expect(mapper.send(:collection_ids)).to eq []
      end
    end
    describe '#collection_with_title' do
      it 'returns Array of coll_id-|-coll_title from DiscoveryIndexer::GeneralMapper.collection_data' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:collection_data).and_return([coll_data1, coll_data2])
        expect(mapper.send(:collection_with_title)).to eq ['coll1_id-|-coll1_title', 'coll2_id-|-coll2_title']
      end
      it 'is an empty array if no collection data is available' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:collection_data).and_return([])
        expect(mapper.send(:collection_with_title)).to eq []
      end
    end
  end

  describe 'constituent data support methods' do
    let(:fake_druid) { 'oo000oo0000' }
    let(:mapper) { described_class.new(fake_druid) }
    let(:stit_data1) { double('discovery-indexer-collection1', searchworks_id: 'stit1_id', title: 'stit1_title') }
    let(:stit_data2) { double('discovery-indexer-collection2', searchworks_id: 'stit2_id', title: 'stit2_title') }
    describe '#constituent_ids' do
      it 'gets them from DiscoveryIndexer::GeneralMapper.constituent_data.searchworks_id' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:constituent_data).and_return([stit_data1, stit_data2])
        expect(mapper.send(:constituent_ids)).to eq ['stit1_id', 'stit2_id']
      end
      it 'is an empty array if no constituent data is available' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:constituent_data).and_return([])
        expect(mapper.send(:constituent_ids)).to eq []
      end
    end
    describe '#constituent_with_title' do
      it 'returns Array of coll_id-|-coll_title from DiscoveryIndexer::GeneralMapper.constituent_data' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:constituent_data).and_return([stit_data1, stit_data2])
        expect(mapper.send(:constituent_with_title)).to eq ['stit1_id-|-stit1_title', 'stit2_id-|-stit2_title']
      end
      it 'is an empty array if no constituent data is available' do
        allow(mapper).to receive(:purlxml)
        expect(mapper).to receive(:constituent_data).and_return([])
        expect(mapper.send(:constituent_with_title)).to eq []
      end
    end
  end
end
