require 'rails_helper'

describe SwMapper do
  before(:all) do
    # @RDF_ns = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
    @mods_ns = "xmlns='#{Mods::MODS_NS}'"
    @fake_druid = 'oo000oo0000'
    @public_xml = "<publicObject id='druid:#{@fake_druid}'><contentMetadata objectId='#{@fake_druid}' type=\"image\"><resource id='#{@fake_druid}_1' sequence=\"1\" type=\"image\"><label>Image 1</label><file id=\"a24.jp2\" mimetype=\"image/jp2\" size=\"3674159\"><imageData width=\"5334\" height=\"3660\"/></file></resource></contentMetadata><identityMetadata></identityMetadata><rightsMetadata></rightsMetadata><oai_dc:dc xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:srw_dc=\"info:srw/schema/1/dc-schema\" xmlns:oai_dc=\"http://www.openarchives.org/OAI/2.0/oai_dc/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd\"></oai_dc:dc><rdf:RDF xmlns:fedora=\"info:fedora/fedora-system:def/relations-external#\" xmlns:fedora-model=\"info:fedora/fedora-system:def/model#\" xmlns:hydra=\"http://projecthydra.org/ns/relations#\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"><rdf:Description></rdf:Description></rdf:RDF></publicObject>"
  end

  context 'doc_hash_from_mods' do
    context 'summary_search solr field from <abstract>' do
      it 'should be populated when the MODS has a top level <abstract> element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><abstract>blah blah</abstract></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:summary_search]).to eq(['blah blah'])
      end
      it 'should have a value for each abstract element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><abstract>one</abstract><abstract>two</abstract></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:summary_search]).to eq(["one", "two"])
      end
      it 'should not be present when there is no top level <abstract> element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><abstract>one</abstract></relatedItem></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:summary_search]).to eq(nil)
      end
      it 'should not be present if there are only empty abstract elements in the MODS' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><abstract/></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:summary_search]).to eq(nil)
      end
      it 'summary_display should not be populated - it is a copy field' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><abstract>blah blah</abstract></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:summary_display]).to eq(nil)
      end
    end # summary_search / <abstract>

    context 'physical solr field from <physicalDescription><extent>' do
      it 'should be populated when the MODS has mods/physicalDescription/extent element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><physicalDescription><extent>blah blah</extent></physicalDescription></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:physical]).to eq(['blah blah'])
      end
      it 'should have a value for each extent element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><physicalDescription><extent>one</extent><extent>two</extent></physicalDescription><physicalDescription><extent>three</extent></physicalDescription></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:physical]).to eq(["one", "two", "three"])
      end
      it 'should not be present when there is no top level <physicalDescription> element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><physicalDescription><extent>foo</extent></physicalDescription></relatedItem></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:physical]).to eq(nil)
      end
      it 'should not be present if there are only empty physicalDescription or extent elements in the MODS' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><physicalDescription/><physicalDescription><extent/></physicalDescription></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:physical]).to eq(nil)
      end
    end # physical field from physicalDescription/extent

    context 'url_suppl solr field from /mods/relatedItem/location/url' do
      it 'should be populated when the MODS has mods/relatedItem/location/url' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><location><url>url.org</url></location></relatedItem></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:url_suppl]).to eq(['url.org'])
      end
      it 'should have a value for each mods/relatedItem/location/url element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><location><url>one</url></location><location><url>two</url><url>three</url></location></relatedItem><relatedItem><location><url>four</url></location></relatedItem></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:url_suppl]).to eq(["one", "two", "three", "four"])
      end
      it 'should not be populated from /mods/location/url element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><location><url>hi</url></location></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:url_suppl]).to eq(nil)
      end
      it 'should not be present if there are only empty relatedItem/location/url elements in the MODS' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><location><url/></location></relatedItem><relatedItem><location/></relatedItem><relatedItem/><note>notit</note></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:url_suppl]).to eq(nil)
      end
    end

    context 'toc_search solr field from <tableOfContents>' do
      it 'should have a value for each tableOfContents element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><tableOfContents>one</tableOfContents><tableOfContents>two</tableOfContents></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:toc_search]).to eq(["one", "two"])
      end
      it 'should not be present when there is no top level <tableOfContents> element' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><relatedItem><tableOfContents>foo</tableOfContents></relatedItem></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:toc_search]).to eq(nil)
      end
      it 'should not be present if there are only empty tableOfContents elements in the MODS' do
        mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>still image</typeOfResource><tableOfContents/><note>notit</note></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:toc_search]).to eq(nil)
      end
    end

    context 'format fields' do
      context 'format_main_ssim' do
        it 'should have a value when MODS data provides' do
          mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>software, multimedia</typeOfResource><genre>dataset</genre></mods>"

          setup_with_xml(@fake_druid, mods_xml, @public_xml)

          expect(@result_doc[:format_main_ssim]).to eq(['Dataset'])
        end
        it 'should return empty Array if there is no value' do
          mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource><note>nope</note></typeOfResource></mods>"

          setup_with_xml(@fake_druid, mods_xml, @public_xml)

          expect(@result_doc[:format_main_ssim]).to eq([])
        end
      end
      context 'format Solr field' do
        it 'should have a value when MODS data provides' do
          mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource>software, multimedia</typeOfResource></mods>"

          setup_with_xml(@fake_druid, mods_xml, @public_xml)

          expect(@result_doc[:format]).to eq(['Computer File'])
        end
        it 'should return empty Array if there is no value' do
          mods_xml = "<mods #{@mods_ns}><titleInfo><title>Item title</title></titleInfo><typeOfResource><note>nope</note></typeOfResource></mods>"

          setup_with_xml(@fake_druid, mods_xml, @public_xml)

          expect(@result_doc[:format]).to eq([])
        end
      end
    end

    context 'title fields' do
      before(:all) do
        @mods_xml = "<mods #{@mods_ns}><titleInfo><title>Jerk</title><nonSort>The</nonSort><subTitle>is whom?</subTitle></titleInfo><titleInfo><title>Joke</title></titleInfo><titleInfo type='alternative'><title>Alternative</title></titleInfo><typeOfResource>still image</typeOfResource></mods>"
      end
      before(:each) do
        setup_with_xml(@fake_druid, @mods_xml, @public_xml)
      end
      context 'search fields' do
        it 'title_245a_search' do
          expect(@result_doc[:title_245a_search]).to eq('The Jerk')
        end
        it 'title_245_search' do
          expect(@result_doc[:title_245_search]).to eq('The Jerk : is whom?')
        end
        it 'title_variant_search' do
          expect(@result_doc[:title_variant_search]).to eq(["Joke", "Alternative"])
        end
        it 'title_related_search should not be populated from MODS' do
          expect(@result_doc[:title_related_search]).to eq(nil)
        end
      end
      context 'display fields' do
        it 'title_display' do
          expect(@result_doc[:title_display]).to eq('The Jerk : is whom?')
        end
        it 'title_245a_display' do
          expect(@result_doc[:title_245a_display]).to eq('The Jerk')
        end
        it 'title_245c_display should not be populated from MODS' do
          expect(@result_doc[:title_245c_display]).to eq(nil)
        end
        it 'title_full_display' do
          expect(@result_doc[:title_full_display]).to eq('The Jerk : is whom?')
        end
        it 'should remove trailing commas in title_display' do
          setup_with_xml(@fake_druid, @mods_xml, @public_xml)
          expect(@result_doc[:title_display]).to eq('The Jerk : is whom?')
        end
        it 'title_variant_display should not be populated - it is a copy field' do
          expect(@result_doc[:title_variant_display]).to eq(nil)
        end
      end
      it 'title_sort' do
        expect(@result_doc[:title_sort]).to eq('Jerk is whom')
      end
    end # title fields

    context 'author fields' do
      before(:all) do
        @mods_xml = "<mods #{@mods_ns}><name type='personal'><namePart type='given'>John</namePart><namePart type='family'>Huston</namePart><role><roleTerm type='code' authority='marcrelator'>drt</roleTerm></role><displayForm>q</displayForm></name><name type='personal'><namePart>Crusty The Clown</namePart></name><name type='corporate'><namePart>Watchful Eye</namePart></name><name type='corporate'><namePart>Exciting Prints</namePart><role><roleTerm type='text'>lithographer</roleTerm></role></name><name type='conference'><namePart>conference</namePart></name><typeOfResource>still image</typeOfResource></mods>"
      end
      before(:each) do
        setup_with_xml(@fake_druid, @mods_xml, @public_xml)
      end
      context 'search fields' do
        it 'author_1xx_search' do
          expect(@result_doc[:author_1xx_search]).to eq('Crusty The Clown')
        end
        it 'author_7xx_search' do
          expect(@result_doc[:author_7xx_search]).to eq(['q', 'Watchful Eye', 'Exciting Prints', 'conference'])
        end
        it 'author_8xx_search should not be populated from MODS' do
          expect(@result_doc[:author_8xx_search]).to eq(nil)
        end
      end
      context 'facet fields' do
        it 'author_person_facet' do
          expect(@result_doc[:author_person_facet]).to eq(['q', 'Crusty The Clown'])
        end
        it 'author_other_facet' do
          expect(@result_doc[:author_other_facet]).to eq(['Watchful Eye', 'Exciting Prints', 'conference'])
        end
      end
      context 'display fields' do
        it 'author_person_display' do
          expect(@result_doc[:author_person_display]).to eq(['q', 'Crusty The Clown'])
        end
        it 'author_person_full_display' do
          expect(@result_doc[:author_person_full_display]).to eq(['q', 'Crusty The Clown'])
        end
        it 'author_corp_display' do
          expect(@result_doc[:author_corp_display]).to eq(['Watchful Eye', 'Exciting Prints'])
        end
        it 'author_meeting_display' do
          expect(@result_doc[:author_meeting_display]).to eq(['conference'])
        end
      end
      it 'author_sort' do
        expect(@result_doc[:author_sort]).to eq('Crusty The Clown')
      end
    end # author fields

    context 'subject fields' do
      before(:all) do
        @genre = 'genre top level'
        @cart_coord = '6 00 S, 71 30 E'
        @s_genre = 'genre in subject'
        @geo = 'Somewhere'
        @geo_code = 'us'
        @hier_geo_country = 'France'
        @s_name = 'name in subject'
        @occupation = 'worker bee'
        @temporal = 'temporal'
        @s_title = 'title in subject'
        @topic = 'topic'
      end
      before(:each) do
        @mods_xml = "<mods #{@mods_ns}><genre>#{@genre}</genre><subject><cartographics><coordinates>#{@cart_coord}</coordinates></cartographics></subject><subject><genre>#{@s_genre}</genre></subject><subject><geographic>#{@geo}</geographic></subject><subject><geographicCode authority='iso3166'>#{@geo_code}</geographicCode></subject><subject><hierarchicalGeographic><country>#{@hier_geo_country}</country></hierarchicalGeographic></subject><subject><name><namePart>#{@s_name}</namePart></name></subject><subject><occupation>#{@occupation}</occupation></subject><subject><temporal>#{@temporal}</temporal></subject><subject><titleInfo><title>#{@s_title}</title></titleInfo></subject><subject><topic>#{@topic}</topic></subject><typeOfResource>still image</typeOfResource></mods>"
        setup_with_xml(@fake_druid, @mods_xml, @public_xml)
      end
      context 'search fields' do
        context 'topic_search' do
          it 'should only include genre and topic' do
            expect(@result_doc[:topic_search]).to eq([@genre, @topic])
          end
          context 'functional tests checking results from stanford-mods methods' do
            it 'should be nil if there are no values in the MODS' do
              @mods_xml = "<mods #{@mods_ns}><note>notit</note><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:topic_search]).to eq(nil)
            end
            it 'should not be nil if there are only subject/topic elements (no <genre>)' do
              @mods_xml = "<mods #{@mods_ns}><subject><topic>#{@topic}</topic></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)

              expect(@result_doc[:topic_search]).to eq([@topic])
            end
            it 'should not be nil if there are only <genre> elements (no subject/topic elements)' do
              @mods_xml = "<mods #{@mods_ns}><genre>#{@genre}</genre><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)

              expect(@result_doc[:topic_search]).to eq([@genre])
            end
            it 'should have a separate value for each topic subelement' do
              @mods_xml = "<mods #{@mods_ns}><subject><topic>first</topic><topic>second</topic></subject><subject><topic>third</topic></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)

              expect(@result_doc[:topic_search]).to eq(["first", "second", "third"])
            end
          end # functional tests checking results from stanford-mods methods
        end # topic_search

        context 'geographic_search' do
          it 'should include geographic and hierarchicalGeographic' do
            expect(@result_doc[:geographic_search]).to eq([@geo, @hier_geo_country])
          end
          xit 'should log an info message when it encounters a geographicCode encoding it does not translate' do
            @mods_xml = "<mods #{@mods_ns}><subject><geographicCode authority='iso3166'>ca</geographicCode></subject><typeOfResource>still image</typeOfResource></mods>"
            # sdb.smods_rec.sw_logger.should_receive(:info).with(#{@fake_druid} has subject geographicCode element with untranslated encoding \(iso3166\): <geographicCode authority=.*>ca<\/geographicCode>/).at_least(1).times
          end
        end # geographic_search

        context 'subject_other_search' do
          it 'should include occupation, subject names, and subject titles' do
            expect(@result_doc[:subject_other_search]).to eq([@occupation, @s_name, @s_title])
          end
          context 'functional tests checking results from stanford-mods methods' do
            it 'should be nil if there are no values in the MODS' do
              @mods_xml = "<mods #{@mods_ns}><note>notit</note><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_search]).to eq(nil)
            end
            it 'should not be nil if there are only subject/name elements' do
              @mods_xml = "<mods #{@mods_ns}><subject><name><namePart>#{@s_name}</namePart></name></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_search]).to eq([@s_name])
            end
            it 'should not be nil if there are only subject/occupation elements' do
              @mods_xml = "<mods #{@mods_ns}><subject><occupation>#{@occupation}</occupation></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_search]).to eq([@occupation])
            end
            it 'should not be nil if there are only subject/titleInfo elements' do
              @mods_xml = "<mods #{@mods_ns}><subject><titleInfo><title>#{@s_title}</title></titleInfo></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_search]).to eq([@s_title])
            end
            it 'should have a separate value for each occupation subelement' do
              @mods_xml = "<mods #{@mods_ns}><subject><occupation>first</occupation><occupation>second</occupation></subject><subject><occupation>third</occupation></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_search]).to eq(["first", "second", "third"])
            end
          end # functional tests checking results from stanford-mods methods
        end # subject_other_search

        context 'subject_other_subvy_search' do
          it 'should include temporal and genre SUBelement' do
            expect(@result_doc[:subject_other_subvy_search]).to eq([@temporal, @s_genre])
          end
          context 'functional tests checking results from stanford-mods methods' do
            it 'should be nil if there are no values in the MODS' do
              @mods_xml = "<mods #{@mods_ns}><note>notit</note><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_subvy_search]).to eq(nil)
            end
            it 'should not be nil if there are only subject/temporal elements (no subject/genre)' do
              @mods_xml = "<mods #{@mods_ns}><subject><temporal>#{@temporal}</temporal></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_subvy_search]).to eq([@temporal])
            end
            it 'should not be nil if there are only subject/genre elements (no subject/temporal)' do
              @mods_xml = "<mods #{@mods_ns}><subject><genre>#{@s_genre}</genre></subject><typeOfResource>still image</typeOfResource></mods>"
              setup_with_xml(@fake_druid, @mods_xml, @public_xml)
              expect(@result_doc[:subject_other_subvy_search]).to eq([@s_genre])
            end
            context 'genre subelement' do
              it 'should have a separate value for each genre element' do
                @mods_xml = "<mods #{@mods_ns}><subject><genre>first</genre><genre>second</genre></subject><subject><genre>third</genre></subject><typeOfResource>still image</typeOfResource></mods>"
                setup_with_xml(@fake_druid, @mods_xml, @public_xml)
                expect(@result_doc[:subject_other_subvy_search]).to eq(["first", "second", "third"])
              end
            end # genre subelement
          end # "functional tests checking results from stanford-mods methods"
        end # subject_other_subvy_search

        context 'subject_all_search' do
          it 'should contain top level <genre> element data' do
            expect(@result_doc[:subject_all_search]).to include(@genre)
          end
          it 'should not contain cartographic sub element' do
            expect(@result_doc[:subject_all_search]).to_not include(@cart_coord)
          end
          it 'should not include codes from hierarchicalGeographic sub element' do
            expect(@result_doc[:subject_all_search]).to_not include(@geo_code)
          end
          it 'should contain all other subject subelement data' do
            expect(@result_doc[:subject_all_search]).to include(@s_genre)
            expect(@result_doc[:subject_all_search]).to include(@geo)
            expect(@result_doc[:subject_all_search]).to include(@hier_geo_country)
            expect(@result_doc[:subject_all_search]).to include(@s_name)
            expect(@result_doc[:subject_all_search]).to include(@occupation)
            expect(@result_doc[:subject_all_search]).to include(@temporal)
            expect(@result_doc[:subject_all_search]).to include(@s_title)
            expect(@result_doc[:subject_all_search]).to include(@topic)
          end
        end # subject_all_search
      end # search fields

      context 'facet fields' do
        context 'topic_facet' do
          it 'should include topic subelement' do
            expect(@result_doc[:topic_facet]).to include(@topic)
          end
          it 'should include sw_subject_names' do
            expect(@result_doc[:topic_facet]).to include(@s_name)
          end
          it 'should include sw_subject_titles' do
            expect(@result_doc[:topic_facet]).to include(@s_title)
          end
          it 'should include occupation subelement' do
            expect(@result_doc[:topic_facet]).to include(@occupation)
          end
          it 'should have the trailing punctuation removed' do
            @mods_xml = "<mods #{@mods_ns}><subject><topic>comma,</topic><occupation>semicolon;</occupation><titleInfo><title>backslash \\</title></titleInfo><name><namePart>internal, punct;uation</namePart></name></subject><typeOfResource>still image</typeOfResource></mods>"
            setup_with_xml(@fake_druid, @mods_xml, @public_xml)
            expect(@result_doc[:topic_facet]).to include('comma')
            expect(@result_doc[:topic_facet]).to include('semicolon')
            expect(@result_doc[:topic_facet]).to include('backslash')
            expect(@result_doc[:topic_facet]).to include('internal, punct;uation')
          end
        end # topic_facet

        context 'geographic_facet' do
          it 'should include geographic subelement' do
            expect(@result_doc[:geographic_facet]).to include(@geo)
          end
          it 'should be like geographic_search with the trailing punctuation (and preceding spaces) removed' do
            @mods_xml = "<mods #{@mods_ns}><subject><geographic>comma,</geographic><geographic>semicolon;</geographic><geographic>backslash \\</geographic><geographic>internal, punct;uation</geographic></subject><typeOfResource>still image</typeOfResource></mods>"
            setup_with_xml(@fake_druid, @mods_xml, @public_xml)
            expect(@result_doc[:geographic_facet]).to include('comma')
            expect(@result_doc[:geographic_facet]).to include('semicolon')
            expect(@result_doc[:geographic_facet]).to include('backslash')
            expect(@result_doc[:geographic_facet]).to include('internal, punct;uation')
          end
        end

        it 'era_facet should be temporal subelement with the trailing punctuation removed' do
          @mods_xml = "<mods #{@mods_ns}><subject><temporal>comma,</temporal><temporal>semicolon;</temporal><temporal>backslash \\</temporal><temporal>internal, punct;uation</temporal></subject><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, @mods_xml, @public_xml)
          expect(@result_doc[:era_facet]).to include('comma')
          expect(@result_doc[:era_facet]).to include('semicolon')
          expect(@result_doc[:era_facet]).to include('backslash')
          expect(@result_doc[:era_facet]).to include('internal, punct;uation')
        end
      end # facet fields
    end # subject fields

    context 'publication date fields' do
      it 'should populate all date fields' do
        mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>13th century AH / 19th CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)

        expect(@result_doc[:pub_date]).to eq('19th century')
        expect(@result_doc[:pub_date_sort]).to eq('1800')
        expect(@result_doc[:publication_year_isi]).to eq('1800')
        expect(@result_doc[:pub_year_tisim]).to eq('1800') # date slider
        expect(@result_doc[:pub_date_display]).to eq('13th century AH / 19th CE')
        expect(@result_doc[:imprint_display]).to eq('13th century AH / 19th CE')
      end
      it 'should not populate the date slider for BC dates' do
        mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>199 B.C.</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"

        setup_with_xml(@fake_druid, mods_xml, @public_xml)
        expect(@result_doc.key?(:pub_year_tisim)).to be_falsy
      end

      context 'pub_date_sort integration tests' do
        it 'should work on normal dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>1945</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date]).to eq('1945')
          expect(@result_doc[:pub_date_sort]).to eq('1945')
        end
        it 'should work on 3 digit dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>945</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date]).to eq('945')
          expect(@result_doc[:pub_date_sort]).to eq('0945')
        end
        it 'should work on century dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>16uu</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date]).to eq('17th century')
          expect(@result_doc[:pub_date_sort]).to eq('1600')
        end
        xit 'should work on 3 digit century dates' do
          pending "this doesn't work right"
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>9uu</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date]).to eq(nil)
          expect(@result_doc[:pub_date_sort]).to eq(nil)
        end
      end # pub_date_sort

      context 'pub_year_tisim for date slider' do
        it 'should take single dateCreated' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>1904</dateCreated></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1904')
        end
        it 'should correctly parse a ranged date' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>Text dated June 4, 1594; miniatures added by 1596</dateCreated></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1594')
        end
        it 'should find year in an expanded English form' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>Aug. 3rd, 1886</dateCreated></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1886')
        end
        it 'should remove question marks and brackets' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>Aug. 3rd, [18]86?</dateCreated></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1886')
        end
        it 'should ignore an s after the decade' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>early 1890s</dateCreated></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1890')
        end
        it 'should choose a date ending with CE if there are multiple dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>7192 AM (li-Adam) / 1684 CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1684')
        end
        it 'should take first year from hyphenated range (for now)' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>1282 AH / 1865-6 CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq('1865')
        end
      end # pub_year_tisim method

      context 'difficult pub dates' do
        xit 'should handle multiple pub dates' do
          pending 'to be implemented - esp for date slider'
        end
        xit 'should choose the latest date???' do
          pending 'to be implemented - esp for sorting and date slider'
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>1904</dateCreated><dateCreated>1905</dateCreated><dateIssued>1906</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_year_tisim]).to eq(%w('1904','1905','1906'))
          expect(@result_doc[:pub_date_sort]).to eq('1904')
          expect(@result_doc[:pub_date]).to eq('1904')
        end

        it 'should handle nnth century dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>13th century AH / 19th CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date]).to eq('19th century')
          expect(@result_doc[:pub_date_sort]).to eq('1800')
          expect(@result_doc[:pub_year_tisim]).to eq('1800')
          expect(@result_doc[:publication_year_isi]).to eq('1800')
          expect(@result_doc[:imprint_display]).to eq('13th century AH / 19th CE')
        end
        it 'should handle multiple CE dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>6 Dhu al-Hijjah 923 AH / 1517 CE -- 7 Rabi I 924 AH / 1518 CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date_sort]).to eq('1517')
          expect(@result_doc[:pub_date]).to eq('1517')
          expect(@result_doc[:pub_year_tisim]).to eq('1517')
        end
        it 'should handle specific century case from walters' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>Late 14th or early 15th century CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date_sort]).to eq('1400')
          expect(@result_doc[:pub_year_tisim]).to eq('1400')
          expect(@result_doc[:publication_year_isi]).to eq('1400')
          expect(@result_doc[:pub_date]).to eq('15th century')
          expect(@result_doc[:imprint_display]).to eq('Late 14th or early 15th century CE')
        end
        it 'should work on explicit 3 digit dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>966 CE</dateIssued></originInfo><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date_sort]).to eq('0966')
          expect(@result_doc[:pub_date]).to eq('966')
          expect(@result_doc[:pub_year_tisim]).to eq('0966')
          expect(@result_doc[:publication_year_isi]).to eq('0966')
          expect(@result_doc[:imprint_display]).to eq('966 CE')
        end
        it 'should work on 3 digit century dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateIssued>3rd century AH / 9th CE</dateIssued><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date_sort]).to eq('0800')
          expect(@result_doc[:pub_date]).to eq('9th century')
          expect(@result_doc[:pub_year_tisim]).to eq('0800')
          expect(@result_doc[:publication_year_isi]).to eq('0800')
          expect(@result_doc[:imprint_display]).to eq('3rd century AH / 9th CE')
        end
        it 'should work on 3 digit BC dates' do
          mods_xml = "<mods #{@mods_ns}><originInfo><dateCreated>300 B.C.</dateCreated><typeOfResource>still image</typeOfResource></mods>"
          setup_with_xml(@fake_druid, mods_xml, @public_xml)
          expect(@result_doc[:pub_date_sort]).to eq('-700')
          expect(@result_doc[:pub_year_tisim]).to eq(nil)
          expect(@result_doc[:pub_date]).to eq('300 B.C.')
          expect(@result_doc[:imprint_display]).to eq('300 B.C.')
        end
      end # difficult pub dates
    end # publication date fields
  end # doc_hash_from_mods

  context 'No catkey' do
    it 'should properly map a digital object for SearchWorks' do
      setup_with_fixture('zz999zz9999', 'item_mods.xml', 'item_public.xml')

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
        collection: ['oo000oo0000'],
        collection_with_title: ['oo000oo0000-|-Collection Name'],
        modsxml: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<mods xmlns=\"http://www.loc.gov/mods/v3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" version=\"3.3\" xsi:schemaLocation=\"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd\">\n  <titleInfo>\n    <title>Item title</title>\n  </titleInfo>\n  <name type=\"personal\">\n    <namePart>Personal name</namePart>\n    <role>\n      <roleTerm authority=\"marcrelator\" type=\"text\">Role</roleTerm>\n    </role>\n  </name>\n  <typeOfResource>still image</typeOfResource>\n  <originInfo>\n    <dateCreated point=\"start\" keyDate=\"yes\">1909</dateCreated>\n    <dateCreated point=\"end\">1915</dateCreated>\n  </originInfo>\n  <relatedItem type=\"host\">\n    <titleInfo>\n      <title>Collection Title</title>\n    </titleInfo>\n    <identifier type=\"uri\">https://purl.stanford.edu/oo000oo0000</identifier>\n    <typeOfResource collection=\"yes\"/>\n  </relatedItem>\n  <accessCondition type=\"copyright\">Access Condition</accessCondition>\n</mods>\n"
      }
      expect(@mapper.convert_to_solr_doc).to eq(expected_doc_hash)
    end
  end
end
