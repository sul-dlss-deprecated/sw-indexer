class SwIndexerEngine < BaseIndexer::MainIndexerEngine
  # This is the main Searchworks indexing function for StanfordSync
  #
  # @param druid [String] is the druid for an object e.g., ab123cd4567
  # @param targets [Hash] is an hash with the targets list along with the
  #   release tag value for each target sent from controller action.
  #
  # @raise it will raise errors if any problems happen in any level
  def index(druid, targets = nil)

    targets ||= {}
    update_marc_record_needed = false

    ##
    # When a target is not in SKIP_CATKEY_CHECK and its true, check the catkey
    # If there is a catkey, set false so that the target gets a delete message and indicate we need a call to the 856 marc generation service.
    # We do this so that the "dor" index doesn't get docs indexed that are
    # already coming from the marc record.
    targets.each do |target_key, target_value|
      next unless target_value == true && !Settings.SKIP_CATKEY_CHECK.include?(target_key)
      if purl_model(druid).catkey.present?
        targets[target_key] = false
        update_marc_record_needed = true
      end
    end

    update_marc_record(druid) if update_marc_record_needed

    # Create the solr document for indexing using the Searchworks mapper and the
    # mods, purl, and collection information
    solr_doc = BaseIndexer.mapper_class_name.constantize.new(druid).convert_to_solr_doc

    # Get SOLR configuration and write solr docs to the appropriate targets
    solr_targets_configs = Settings.SOLR_TARGETS.to_hash.deep_stringify_keys
    BaseIndexer.solr_writer_class_name.constantize.new.process(druid, solr_doc, targets, solr_targets_configs)
  end

  def purl_model(druid)
    DiscoveryIndexer::InputXml::Purlxml.new(druid).load
  end

  def update_marc_record(druid)
    url = "#{Settings.DOR_SERVICES_URL}/objects/#{druid}/update_marc_record"
    conn = Faraday.new(url: url)
    conn.post
  end
end
