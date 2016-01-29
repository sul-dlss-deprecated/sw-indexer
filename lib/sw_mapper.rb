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
    solr_doc.update mods_to_subject_fields
    solr_doc.update mods_to_publication_fields
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
    short_title = modsxml.sw_short_title
    full_title = modsxml.sw_full_title
    {
      title_245a_search: short_title,
      title_245_search: full_title,
      title_variant_search: modsxml.sw_addl_titles,
      title_sort: modsxml.sw_sort_title,
      title_245a_display: short_title,
      title_display: modsxml.sw_title_display,
      title_full_display: full_title
    }
  end

  # @return [Hash] Hash representing the author fields
  def mods_to_author_fields
    person_authors = modsxml.sw_person_authors
    {
      author_1xx_search: modsxml.sw_main_author,
      author_7xx_search: modsxml.sw_addl_authors,
      author_person_facet: person_authors,
      author_other_facet: modsxml.sw_impersonal_authors,
      author_sort: modsxml.sw_sort_author,
      author_corp_display: modsxml.sw_corporate_authors,
      author_meeting_display: modsxml.sw_meeting_authors,
      author_person_display: person_authors,
      author_person_full_display: person_authors
    }
  end

  # @return [Hash] Hash representing the subjects fields
  def mods_to_subject_fields
    {
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
    pub_year_int = modsxml.pub_year_int
    pub_year_for_display = modsxml.pub_date_facet_single_value
    {
      # TODO: need better implementation of pub_search in stanford-mods
      pub_search: modsxml.place,
      pub_year_isi: pub_year_int, # for sorting
      # deprecated pub_date_sort - use pub_year_isi; pub_date_sort is a string and requires weirdness for bc dates
      #   can remove after pub_year_isi is populated for all indexing data (i.e. solrmarc, crez) and app code is changed
      pub_date_sort: modsxml.pub_year_sort_str,
      # TODO: need better implementation of imprint_display in stanford-mods
      imprint_display: modsxml.pub_date_display,

      # deprecated pub_date Solr field - use pub_year_isi for sort key; pub_year_ss for display field
      #   can remove after other fields are populated for all indexing data (i.e. solrmarc, crez) and app code is changed
      pub_date: pub_year_for_display,
      # TODO: need better stanford-mods implementation of early years (add A.D.) and vague years (1950s)
      pub_year_ss: pub_year_for_display,

      # TODO: need better implementation for date slider in stanford-mods (e.g. multiple years when warranted)
      pub_year_tisim: pub_year_int,

      creation_year_isi: modsxml.year_int(modsxml.date_created_elements),
      publication_year_isi: modsxml.year_int(modsxml.date_issued_elements)
    }
  end

  # @return [Hash] Hash representing some fields
  def mods_to_others
    {
      format_main_ssim: modsxml.format_main,
      format: modsxml.format, # deprecated; for backwards compatibility
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

  # deprecated:  keeping in case we need to revert to not having negative numbers in date slider
  #   when removing, also remove positive_int?  methods
  # @return [Fixnum] Hash representing the pub date
  def date_slider_vals_for_pub_year
    sort_year = modsxml.pub_year_int(false)
    return sort_year if positive_int? sort_year
  end

  # @return true if the string parses into an int >= 0
  def positive_int?(str)
    str.to_i >= 0
  rescue
    false
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
    # https://github.com/sul-dlss/sw-indexer-service/issues/34
    # Only return file_ids for images, not for non-image types
    # return purlxml.file_ids if display_type == 'file'
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
