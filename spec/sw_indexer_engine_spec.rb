require 'rails_helper'

describe SwIndexerEngine do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:ckey_doc) { double('PurlThing', catkey: '12345') }
  let(:no_ckey_doc) { double('PurlThing', catkey: nil) }

  describe 'index' do
    context 'for targets that should not be skipped checking' do
      it 'returns nil if there is a catkey present' do
        expect(subject).to receive(:purl_model).with(item_pid).and_return(ckey_doc)
        expect(subject.index(item_pid, 'NOTTOBESKIPPED' => true)).to be_nil
      end
      it 'proceeds with indexing' do
        stub_purl_and_solr

        expect(subject).not_to receive(:purl_model)
        expect(subject.index(item_pid, 'SEARCHWORKSPREVIEW' => true)).to be_nil
      end
    end
    context 'for targets that should be skipped checking' do
      it 'proceeds with indexing' do
        stub_purl_and_solr

        expect(subject).not_to receive(:purl_model).with(item_pid)
        expect(subject.index(item_pid, 'SEARCHWORKSPREVIEW' => true)).to be_nil
      end
    end
    context 'for druids without RDF' do
      it 'completes process' do
        item_xml = Nokogiri::XML(item_image_xml)
        item_xml.xpath('//rdf:RDF', 'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#').remove
        stub_request(:get, 'https://purl.stanford.edu/druid:zz999zz9999.xml')
          .to_return(status: 200, body: item_xml.to_xml)
        expect(subject.index(item_pid, 'SEARCHWORKSPREVIEW' => true)).to be_nil
      end
    end
  end

  def stub_purl_and_solr
    stub_request(:get, 'https://purl.stanford.edu/druid:zz999zz9999.xml')
      .to_return(status: 200, body: item_image_xml)
    stub_request(:get, 'https://purl.stanford.edu/druid:zz999zz9999.mods')
      .to_return(status: 200, body: item_image_xml)
    stub_request(:get, 'https://purl.stanford.edu/oo000oo0000.xml')
      .to_return(status: 200, body: coll_image_xml)
    stub_request(:post, /solr/)
  end
end
