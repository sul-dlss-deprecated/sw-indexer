class SwMapper < DiscoveryIndexer::GeneralMapper
  # You have access to these instance variables:
  # druid = object pid (no "druid:" prefix)
  # modsxml == Stanford::Mods::Record class object (modsxml.mods_ng_xml == Nokogiri document (for custom parsing)
  # @purlxml == DiscoveryIndexer::InputXml::PurlxmlModel class object (@purlxml.public_xml == Nokogiri document (for custom parsing)
  # @collection_data == hash of collections the druid belongs to {'oo000oo0000'=>{label: "Collection Name", catkey: "12345678"}}
  # Create a Hash representing a Solr doc, with all MODS related fields populated.
  # @return [Hash] Hash representing the Solr document
  def convert_to_solr_doc
    solr_doc = {}
    solr_doc[:id] = druid
    solr_doc[:druid] = druid

    solr_doc.update mods_to_title_fields
    solr_doc.update mods_to_author_fields
    solr_doc.update mods_to_subject_search_fields
    solr_doc.update mods_to_publication_fields
    solr_doc.update mods_to_pub_date
    solr_doc.update mods_to_others
    solr_doc.update hard_coded_fields

    solr_doc[:collection] = collection
    solr_doc[:modsxml] = modsxml.to_xml
    solr_doc[:all_search] = modsxml.text.gsub(/\s+/, ' ')
    solr_doc[:display_type] = display_type
    solr_doc[:file_id] = file_ids
    solr_doc[:collection_with_title] = collection_with_title
    solr_doc[:collection_type] = 'Digital Collection' if purlxml.is_collection
    solr_doc
  end

  # @return [Hash] Hash representing the title fields
  def mods_to_title_fields
    # title fields
    {
      title_245a_search: modsxml.sw_short_title,
      title_245_search: modsxml.sw_full_title,
      title_variant_search: modsxml.sw_addl_titles,
      title_sort: modsxml.sw_sort_title,
      title_245a_display: modsxml.sw_short_title,
      title_display: modsxml.sw_title_display,
      title_full_display: modsxml.sw_full_title
    }
  end

  # @return [Hash] Hash representing the author fields
  def mods_to_author_fields
    {
      # author fields
      author_1xx_search: modsxml.sw_main_author,
      author_7xx_search: modsxml.sw_addl_authors,
      author_person_facet: modsxml.sw_person_authors,
      author_other_facet: modsxml.sw_impersonal_authors,
      author_sort: modsxml.sw_sort_author,
      author_corp_display: modsxml.sw_corporate_authors,
      author_meeting_display: modsxml.sw_meeting_authors,
      author_person_display: modsxml.sw_person_authors,
      author_person_full_display: modsxml.sw_person_authors
    }
  end

  # @return [Hash] Hash representing the search fields
  def mods_to_subject_search_fields
    {
      # subject search fields
      topic_search: modsxml.topic_search,
      geographic_search: modsxml.geographic_search,
      subject_other_search: modsxml.subject_other_search,
      subject_other_subvy_search: modsxml.subject_other_subvy_search,
      subject_all_search: modsxml.subject_all_search,
      topic_facet: modsxml.topic_facet,
      geographic_facet: modsxml.geographic_facet,
      era_facet: modsxml.era_facet
    }
  end

  # @return [Hash] Hash representing the publication fields
  def mods_to_publication_fields
    {
      # publication fields
      pub_search: modsxml.place,
      pub_date_sort: modsxml.pub_date_sort,
      imprint_display: modsxml.pub_date_display,
      pub_date: modsxml.pub_date_facet,
      # pub_date_display may be deprecated
      pub_date_display: modsxml.pub_date_display
    }
  end

  # @return [Hash] Hash representing the pub date
  def mods_to_pub_date
    doc_hash = {}
    if positive_int? modsxml.pub_date_sort
      # for date slider
      doc_hash[:pub_year_tisim] = modsxml.pub_date_sort
      # put the displayable year in the correct field
      doc_hash[date_type_sym] = modsxml.pub_date_sort if date_type_sym
    end
    doc_hash
  end

  # @return [Hash] Hash representing some fields
  def mods_to_others
    {
      format_main_ssim: modsxml.format_main,
      format: modsxml.format, # for backwards compatibility
      language: modsxml.sw_language_facet,
      physical: modsxml.term_values([:physical_description, :extent]),
      summary_search: modsxml.term_values(:abstract),
      toc_search: modsxml.term_values(:tableOfContents),
      url_suppl: modsxml.term_values([:related_item, :location, :url])
    }
  end

  def hard_coded_fields
    {
      url_fulltext: "https://purl.stanford.edu/#{druid}",
      access_facet: 'Online',
      building_facet: 'Stanford Digital Repository'
    }
  end

  protected

  # @return true if the string parses into an int that is >= 0
  # @return false if the string parses into an int that is < 0
  def positive_int?(str)
    return true if str.to_i >= 0
    false
  end

  # determines particular flavor of displayable publication year field
  # @return Solr field name as a symbol
  def date_type_sym
    vals = modsxml.term_values([:origin_info, :dateIssued])
    return :publication_year_isi if vals && vals.length > 0
    vals = modsxml.term_values([:origin_info, :dateCreated])
    return :creation_year_isi if vals && vals.length > 0
    nil
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
  # @return [String] 'file' or DOR content type
  def display_type
    if purlxml.dor_display_type.present?
      purlxml.dor_display_type
    else
      case purlxml.dor_content_type
      when 'book'
        'book'
      when 'image', 'manuscript', 'map'
        'image'
      else
        'file'
      end
    end
  end

  # the @id attribute of resource/file elements that match the display_type
  # @return [Array<String>] filenames
  def file_ids
    return if purlxml.is_collection
    return purlxml.image_ids if %w(image book).include?(display_type)
    return purlxml.file_ids if display_type == 'file'
  end

  # the collection druid for items in a collection
  # @return [Array<String>] druids
  def collection
    collection_data.map(&:searchworks_id)
  end

  # The collection druid or ckey and collection title for items
  # in a collection for display in SearchWorks
  # @return [Array<String>] druid -|- title or ckey -|- title
  def collection_with_title
    collection_data.map do |collection|
      "#{collection.searchworks_id}-|-#{collection.title}"
    end
  end
end
