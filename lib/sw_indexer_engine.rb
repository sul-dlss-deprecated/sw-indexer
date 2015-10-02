class SwIndexerEngine < BaseIndexer::MainIndexerEngine
  # This is the main Searchworks indexing function for StanfordSync
  #
  # @param druid [String] is the druid for an object e.g., ab123cd4567
  # @param targets [Hash] is an hash with the targets list along with the
  #   release tag value for each target; if it is nil, the method will read the
  #   target list and release tag value from release_tags
  #
  # @raise it will raise errors if any problems happen in any level
  def index(druid, targets = nil)
    # Read PURL XML for the druid
    purl_model = read_purl(druid)

    # If a catkey exists in the purl_model, stop processing the druid and leave
    # the method because access to the digital object will be provided by an 856
    # in the corresponding MARC record
    return if purl_model.catkey

    # If no catkey in the purl_model, read the MODS for the druid
    mods_model = read_mods(druid)

    # Get the information about the collection the druid is a member of to
    # include in the indexed solr doc
    collection_data = collection_data(purl_model.collection_druids)

    # Create the solr document for indexing using the Searchworks mapper and the
    # mods, purl, and collection information
    solr_doc = BaseIndexer.mapper_class_name.constantize.new(druid, mods_model, purl_model, collection_data).convert_to_solr_doc

    # Get list of indexing targets from parameter input or release_tags directly
    # from the purl model
    targets_hash = {}
    if targets.nil? || targets.length == 0
      targets_hash = purl_model.release_tags_hash
    else
      targets_hash = targets
    end

    # Get SOLR configuration and write solr docs to the appropriate targets
    solr_targets_configs = BaseIndexer.solr_configuration_class_name.constantize.instance.get_configuration_hash
    BaseIndexer.solr_writer_class_name.constantize.new.process(druid, solr_doc, targets_hash, solr_targets_configs)
  end
end
