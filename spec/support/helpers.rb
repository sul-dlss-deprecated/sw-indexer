##
# Helper methods used for tests
module Helpers
  def stub_solr
    stub_request(:post, /solr/)
      .to_return(status: 200, body: '')
  end

  def stub_purl_and_solr(druid, purl_xml, mods_xml)
    stub_purl(druid, purl_xml, mods_xml)
    stub_solr
  end

  def stub_purl(druid, purl_xml, mods_xml)
    stub_request(:get, "https://purl.stanford.edu/#{druid}.xml")
      .to_return(status: 200, body: purl_xml)
    stub_request(:get, "https://purl.stanford.edu/#{druid}.mods")
      .to_return(status: 200, body: mods_xml)
  end

  def stub_collection(druid, coll_xml)
    stub_request(:get, "https://purl.stanford.edu/#{druid}.xml")
      .to_return(status: 200, body: coll_xml)
  end
end
