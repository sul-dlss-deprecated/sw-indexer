require 'rails_helper'

describe SwIndexerEngine do
  include XmlFixtures
  let(:smods_rec) { Stanford::Mods::Record.new }
  let(:item_pid) { 'druid:zz999zz9999' }
  let(:ckey_doc) { double('PurlThing', catkey: '12345') }
  subject { described_class.new }

  describe 'index' do
    it 'returns nil if there is a catkey present' do
      allow(subject).to receive(:purl_model).with(item_pid).and_return(ckey_doc)
      expect(subject.index(item_pid)).to be_nil
    end

  end
end
