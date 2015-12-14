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
    # If a catkey exists in the purl_model, stop processing the druid and leave
    # the method because access to the digital object will be provided by an 856
    # in the corresponding MARC record
    return if @purl_model.catkey.present?

    # Create the solr document for indexing using the Searchworks mapper and the
    # mods, purl, and collection information
    solr_doc = BaseIndexer.mapper_class_name.constantize.new(druid).convert_to_solr_doc

    # Get SOLR configuration and write solr docs to the appropriate targets
    solr_targets_configs = BaseIndexer.solr_configuration_class_name.constantize.instance.get_configuration_hash
    BaseIndexer.solr_writer_class_name.constantize.new.process(druid, solr_doc, targets, solr_targets_configs)
  end
end
