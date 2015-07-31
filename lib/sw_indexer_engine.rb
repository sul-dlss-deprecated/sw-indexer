class SwIndexerEngine < BaseIndexer::MainIndexerEngine
  # It is the main indexing function
  #
  # @param druid [String] is the druid for an object e.g., ab123cd4567
  # @param targets [Array] is an array with the targets list to index towards,
  #   if it is nil, the method will read the target list from release_tags
  #
  # @raise it will raise erros if there is any problems happen in any level
  def index druid, targets=nil
    # Read input mods and purl
    purl_model =  read_purl(druid)
    if purl_model.catkey == nil
      mods_model =  read_mods(druid)
      collection_data = get_collection_data(purl_model.collection_druids)

      # Map the input to solr_doc
      solr_doc =  BaseIndexer.mapper_class_name.constantize.new(druid, mods_model, purl_model, collection_data).convert_to_solr_doc

      # Get target list
      targets_hash={}
      if targets.nil? or targets.length == 0
        targets_hash = purl_model.release_tags_hash
      else
        targets_hash = get_targets_hash_from_param(targets)
      end

      targets_hash = update_targets_before_write(targets_hash, purl_model)

      # Get SOLR configuration and write
      solr_targets_configs = BaseIndexer.solr_configuration_class_name.constantize.instance.get_configuration_hash
      BaseIndexer.solr_writer_class_name.constantize.new.process( druid, solr_doc, targets_hash, solr_targets_configs)
    end
  end

  # It allows the consumer to modify the targets list before doing the final writing
  #  to the solr core. Default behavior returns the targets_hash as it is
  # @param targets_hash [Hash] a hash of targets with true value
  # @param purl_model [DiscoveryIndexer::Reader::PurlxmlModel]  represents the purlxml model
  # @return [Hash] a hash of targets 
  def update_targets_before_write(targets_hash, purl_model)
  	if purl_model.catkey != nil
  	  targets_hash["sw_dev"] = false
      targets_hash["sw_stage"] = false
      targets_hash["sw_prod"] = false
  	end
    return targets_hash
  end
end