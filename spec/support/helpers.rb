##
# Helper methods used for tests
module Helpers

  def dor_services_stub
    stub_request(:post, "http://localhost:9292/v1/objects/druid:zz999zz9999/update_marc_record")
          .with(:headers => {'Accept'=>'*/*', 'Content-Length'=>'0'})
          .to_return(:status => 200, :body => "", :headers => {})
  end

  def post_stub_solr
    stub_request(:post, /solr/)
          .with(body: /^{"add"/)
          .to_return(status: 200, body: '')
  end

  def delete_stub_solr
    stub_request(:post, /solr/)
          .with(body: /^{"delete"/)
          .to_return(status: 200, body: '')
  end

  def stub_purl_and_solr(druid, purl_xml, mods_xml)
    stub_purl(druid, purl_xml, mods_xml)
    post_stub_solr
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
