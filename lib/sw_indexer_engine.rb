class SwIndexerEngine < BaseIndexer::MainIndexerEngine
  # It allows the consumer to modify the targets list before doing the final writing
  #  to the solr core. Default behavior returns the targets_hash as it is
  # @param targets_hash [Hash] a hash of targets with true value
  # @param purl_model [DiscoveryIndexer::Reader::PurlxmlModel]  represents the purlxml model
  # @return [Hash] a hash of targets 
  def update_targets_before_write(targets_hash, purl_model)
  	if purl_model.catkey != nil
  	  targets_hash["sw_dev"] = false
  	end
    return targets_hash
  end
end