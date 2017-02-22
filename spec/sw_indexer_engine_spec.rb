require 'rails_helper'

describe SwIndexerEngine do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:ckey_doc) { double('PurlThing', catkey: '12345') }
  let(:no_ckey_doc) { double('PurlThing', catkey: nil) }
  before :each do
    @dor_services_stub = dor_services_stub
    @delete_solr_stub = delete_stub_solr
    @post_solr_stub = post_stub_solr
    stub_purl('druid:zz999zz9999', item_image_xml, item_image_mods)
    stub_collection('oo000oo0000', coll_image_xml)
  end

  describe 'index' do
    context 'for targets that should be checked for catkeys' do
      # NOTE: The MYSOLR target is will have catkey checks applied
      let(:catkey_check_target) { 'MYSOLR' }
      it 'does not index but instead calls solr delete and calls dor-services 856 generation call for a record with a catkey' do
        allow(subject).to receive(:purl_model).with(item_pid).and_return(ckey_doc)
        subject.index(item_pid, catkey_check_target => true)
        expect(@delete_solr_stub).to have_been_requested.once
        expect(@dor_services_stub).to have_been_requested.once
        expect(@post_solr_stub).not_to have_been_requested
      end
      it 'indexes and does not call solr delete nor dor-services 856 generation call for a record with no catkey' do
        allow(subject).to receive(:purl_model).with(item_pid).and_return(no_ckey_doc)
        subject.index(item_pid, catkey_check_target => true)
        expect(@delete_solr_stub).not_to have_been_requested
        expect(@dor_services_stub).not_to have_been_requested
        expect(@post_solr_stub).to have_been_requested.once
      end
    end
    context 'for targets that should NOT be checked for catkeys' do
      # NOTE: The SEARCHWORKSPREVIEW target is configured to skip all catkey checks
      let(:no_catkey_check_target) { 'SEARCHWORKSPREVIEW' }
      it 'indexes and does not call solr delete nor dor-services 856 generation call for a record even with a catkey' do
        allow(subject).to receive(:purl_model).with(item_pid).and_return(ckey_doc)
        expect(subject).not_to receive(:purl_model)
        subject.index(item_pid, no_catkey_check_target => true)
        expect(@delete_solr_stub).not_to have_been_requested
        expect(@dor_services_stub).not_to have_been_requested
        expect(@post_solr_stub).to have_been_requested.once
      end
      it 'indexes and does not call solr delete nor dor-services 856 generation call for a record with no catkey' do
        allow(subject).to receive(:purl_model).with(item_pid).and_return(no_ckey_doc)
        expect(subject).not_to receive(:purl_model)
        subject.index(item_pid, no_catkey_check_target => true)
        expect(@delete_solr_stub).not_to have_been_requested
        expect(@dor_services_stub).not_to have_been_requested
        expect(@post_solr_stub).to have_been_requested.once
      end
    end
    context 'for a non-configured target' do
      # NOTE: The BOGUS target is not configured in test.yml
      let(:bogus_target) { 'BOGUS' }
      it 'does not index and does not call solr delete nor dor-services 856 generation call for a record with no catkey' do
        allow(subject).to receive(:purl_model).with(item_pid).and_return(no_ckey_doc)
        subject.index(item_pid, bogus_target => true)
        expect(@delete_solr_stub).not_to have_been_requested
        expect(@dor_services_stub).not_to have_been_requested
        expect(@post_solr_stub).not_to have_been_requested
      end
    end
  end
end
