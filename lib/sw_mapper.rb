class SwMapper < DiscoveryIndexer::Mapper::GeneralMapper

  # You have access to these instance variables:
  # @druid = object pid (no "druid:" prefix)
  # @modsxml == Stanford::Mods::Record class object (@modsxml.mods_ng_xml == Nokogiri document (for custom parsing)
  # @purlxml == DiscoveryIndexer::InputXml::PurlxmlModel class object (@purlxml.public_xml == Nokogiri document (for custom parsing)
  # @collection_names == hash of collections the @druid belongs to (key = collection druid, value = collection name)
  def convert_to_solr_doc()
    solr_doc = super
    solr_doc[:display_type] = display_type
    solr_doc[:file_id] = file_ids
#    solr_doc[:druid] = @druid
#    solr_doc[:url_fulltext] = "http://purl.stanford.edu/#{@druid}"
#    solr_doc[:access_facet] = 'Online'
#    solr_doc[:building_facet] = 'Stanford Digital Repository'
#    solr_doc[:collection] = collection
    solr_doc[:collection_with_title] = collection_with_title
#    solr_doc[:modsxml] = @modsxml.to_xml
    solr_doc[:author_sort] = @modsxml.sw_sort_author
    return solr_doc
  end

  # value is used to tell SearchWorks UI app of specific display needs for objects
  # a config file value for add_display_type can be used to prepend a string to 
  #  xxx_collection or xxx_object 
  # e.g., Hydrus objects are a special display case
  # Based on a value of :add_display_type in a collection's config yml file
  # 
  # information on DOR content types:
  #   https://consul.stanford.edu/display/chimera/DOR+content+types%2C+resource+types+and+interpretive+metadata
  #
  # @return [String] 'collection' or DOR content type
  def display_type
    case @purlxml.dor_content_type
      when 'book'
        'book'
      when 'image', 'manuscript', 'map'
        'image'
      else
        'file'
    end
  end

  # the @id attribute of resource/file elements that match the display_type, including extension
  # @return [Array<String>] filenames
  def file_ids
    @file_ids ||= begin
      ids = []
      if display_type == "image"
        ids = @purlxml.image_ids
      elsif display_type == "file"
        ids = @purlxml.file_ids
      end
      return nil if ids.empty?
      ids
    end
  end

  # the collection druid for items in a collection
  # @return [Array<String>] druids
  def collection
    @collection ||= begin
      coll_druids = []
      @purlxml.collection_druids.each do | cdruid |
        coll_druids.push cdruid
      end
      return nil if coll_druids.empty?
      coll_druids
    end
  end

  # The collection druid and collection title for items in a collection
  # for display in SearchWorks
  # @return [Array<String>] druid -|- title
  def collection_with_title
    @collection_with_title ||= begin
      coll_title = []
      @collection_names.each do | key, value|
        coll_title.push "#{key}-|-#{value}"
      end
      return nil if coll_title.empty?
      coll_title
    end
  end
end
