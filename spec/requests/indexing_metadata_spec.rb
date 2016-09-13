require 'rails_helper'

describe 'Indexing various types of metadata', type: :request do
  include XmlFixtures
  context 'with no RDF' do
    before do
      item_xml = Nokogiri::XML(item_image_xml)
      item_xml.xpath('//rdf:RDF', 'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#').remove
      stub_purl_and_solr('zz999zz9999', item_xml.to_xml, item_image_mods)
    end
    it 'indexes successfully' do
      patch '/items/druid:zz999zz9999/subtargets/SEARCHWORKSPREVIEW'
      expect(response.status).to eq 200
    end
  end
  context 'with no dublin core' do
    before do
      item_xml = Nokogiri::XML(item_image_xml)
      item_xml.xpath('//dc:dc', 'dc' => 'http://purl.org/dc/elements/1.1/').remove
      item_xml.to_xml
      stub_purl_and_solr('zz999zz9999', item_xml.to_xml, item_image_mods)
      stub_collection('oo000oo0000', coll_image_xml)
    end
    it 'indexes successfully' do
      patch '/items/druid:zz999zz9999/subtargets/SEARCHWORKSPREVIEW'
      expect(response.status).to eq 200
    end
  end
  context 'with no identity metadata' do
    before do
      item_xml = Nokogiri::XML(item_image_xml)
      item_xml.xpath('//identityMetadata').remove
      item_xml.to_xml
      stub_purl_and_solr('zz999zz9999', item_xml.to_xml, item_image_mods)
      stub_collection('oo000oo0000', coll_image_xml)
    end
    it 'indexes successfully' do
      patch '/items/druid:zz999zz9999/subtargets/SEARCHWORKSPREVIEW'
      expect(response.status).to eq 200
    end
  end
  context 'with no rights metadata' do
    before do
      item_xml = Nokogiri::XML(item_image_xml)
      item_xml.xpath('//rightsMetadata').remove
      item_xml.to_xml
      stub_purl_and_solr('zz999zz9999', item_xml.to_xml, item_image_mods)
      stub_collection('oo000oo0000', coll_image_xml)
    end
    it 'indexes successfully' do
      patch '/items/druid:zz999zz9999/subtargets/SEARCHWORKSPREVIEW'
      expect(response.status).to eq 200
    end
  end
end
