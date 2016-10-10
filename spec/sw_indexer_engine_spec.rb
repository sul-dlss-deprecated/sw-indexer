require 'rails_helper'

describe SwIndexerEngine do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:ckey_doc) { double('PurlThing', catkey: '12345') }
  let(:no_ckey_doc) { double('PurlThing', catkey: nil) }

  describe 'index' do
    context 'for targets that should not be skipped checking' do
      it 'calls solr delete for the index' do
        expect(subject).to receive(:purl_model).with(item_pid).and_return(ckey_doc)
        stub_purl('druid:zz999zz9999', item_image_xml, item_image_mods)
        stub_collection('oo000oo0000', coll_image_xml)
        solr_stub = stub_request(:post, /solr/)
          .with(body: /^.*<delete><id>druid:zz999zz9999/)
          .to_return(status: 200, body: '')
        subject.index(item_pid, 'MYSOLR' => true)
        expect(solr_stub).to have_been_requested
      end
      it 'proceeds with indexing' do
        stub_purl_and_solr('druid:zz999zz9999', item_image_xml, item_image_mods)
        stub_collection('oo000oo0000', coll_image_xml)

        expect(subject).not_to receive(:purl_model)
        expect(subject.index(item_pid, 'SEARCHWORKSPREVIEW' => true)).to be_nil
      end
    end
    context 'for targets that should be skipped checking' do
      it 'proceeds with indexing' do
        stub_purl_and_solr('druid:zz999zz9999', item_image_xml, item_image_mods)
        stub_collection('oo000oo0000', coll_image_xml)

        expect(subject).not_to receive(:purl_model).with(item_pid)
        expect(subject.index(item_pid, 'SEARCHWORKSPREVIEW' => true)).to be_nil
      end
    end
  end
end
