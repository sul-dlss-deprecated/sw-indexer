class SwMapper < DiscoveryIndexer::Mapper::GeneralMapper

  # You have access to these instance variables:
  # @druid = object pid (no "druid:" prefix)
  # @modsxml == Stanford::Mods::Record class object (@modsxml.mods_ng_xml == Nokogiri document (for custom parsing)
  # @purlxml == DiscoveryIndexer::InputXml::PurlxmlModel class object (@purlxml.public_xml == Nokogiri document (for custom parsing)
  # @collection_data == hash of collections the @druid belongs to {'oo000oo0000'=>{label: "Collection Name", catkey: "12345678"}}
  # Create a Hash representing a Solr doc, with all MODS related fields populated.
  # @return [Hash] Hash representing the Solr document
  def convert_to_solr_doc()
    solr_doc = {}
    solr_doc[:id] = @druid
    solr_doc[:druid] = @druid

    solr_doc.update mods_to_title_fields
    solr_doc.update mods_to_author_fields
    solr_doc.update mods_to_subject_search_fields
    solr_doc.update mods_to_publication_fields
    solr_doc.update mods_to_pub_date
    solr_doc.update mods_to_others
    solr_doc.update hard_coded_fields

    solr_doc[:collection] = collection
    solr_doc[:modsxml] = @modsxml.to_xml
    solr_doc[:all_search] = @modsxml.text.gsub(/\s+/, ' ')
    solr_doc[:display_type] = display_type
    solr_doc[:file_id] = file_ids
    solr_doc[:collection_with_title] = collection_with_title
    solr_doc[:collection_type] = "Digital Collection" if @purlxml.is_collection
    return solr_doc
  end

  # @return [Hash] Hash representing the title fields
  def mods_to_title_fields
    # title fields
    doc_hash = {
      :title_245a_search => @modsxml.sw_short_title,
      :title_245_search => @modsxml.sw_full_title,
      :title_variant_search => @modsxml.sw_addl_titles,
      :title_sort => @modsxml.sw_sort_title,
      :title_245a_display => @modsxml.sw_short_title,
      :title_display => @modsxml.sw_title_display,
      :title_full_display => @modsxml.sw_full_title,
    }
    doc_hash
  end

  # @return [Hash] Hash representing the author fields
  def mods_to_author_fields
    doc_hash = {
      # author fields
      :author_1xx_search => @modsxml.sw_main_author,
      :author_7xx_search => @modsxml.sw_addl_authors,
      :author_person_facet => @modsxml.sw_person_authors,
      :author_other_facet => @modsxml.sw_impersonal_authors,
      :author_sort => @modsxml.sw_sort_author,
      :author_corp_display => @modsxml.sw_corporate_authors,
      :author_meeting_display => @modsxml.sw_meeting_authors,
      :author_person_display => @modsxml.sw_person_authors,
      :author_person_full_display => @modsxml.sw_person_authors,
    }
    doc_hash
  end

  # @return [Hash] Hash representing the search fields
  def mods_to_subject_search_fields
    doc_hash = {
      # subject search fields
      :topic_search => @modsxml.topic_search,
      :geographic_search => @modsxml.geographic_search,
      :subject_other_search => @modsxml.subject_other_search,
      :subject_other_subvy_search => @modsxml.subject_other_subvy_search,
      :subject_all_search => @modsxml.subject_all_search,
      :topic_facet => @modsxml.topic_facet,
      :geographic_facet => @modsxml.geographic_facet,
      :era_facet => @modsxml.era_facet,
    }
  end

  # @return [Hash] Hash representing the publication fields
  def mods_to_publication_fields
    doc_hash = {
      # publication fields
      :pub_search =>  @modsxml.place,
      :pub_date_sort =>  @modsxml.pub_date_sort,
      :imprint_display =>  @modsxml.pub_date_display,
      :pub_date =>  @modsxml.pub_date_facet,
      :pub_date_display =>  @modsxml.pub_date_display, # pub_date_display may be deprecated
    }
  end

  # @return [Hash] Hash representing the pub date
  def mods_to_pub_date
    doc_hash = {}
    pub_date_sort = @modsxml.pub_date_sort
    if is_positive_int? pub_date_sort
      doc_hash[:pub_year_tisim] =  pub_date_sort # for date slider
      # put the displayable year in the correct field, :creation_year_isi for example
      doc_hash[date_type_sym] =  @modsxml.pub_date_sort  if date_type_sym
    end
    return doc_hash
  end

  # @return [Hash] Hash representing some fields
  def mods_to_others
    doc_hash = {
      :format_main_ssim => format_main_ssim,
      :format => format, # for backwards compatibility
      :language => @modsxml.sw_language_facet,
      :physical =>  @modsxml.term_values([:physical_description, :extent]),
      :summary_search => @modsxml.term_values(:abstract),
      :toc_search => @modsxml.term_values(:tableOfContents),
      :url_suppl => @modsxml.term_values([:related_item, :location, :url]),
    }
    return doc_hash
  end

  def hard_coded_fields
    doc_hash = {
      :url_fulltext => "http://purl.stanford.edu/#{@druid}",
      :access_facet => 'Online',
      :building_facet => 'Stanford Digital Repository',
    }
  end
  # select one or more format values from the controlled vocabulary here:
  #   http://searchworks-solr-lb.stanford.edu:8983/solr/select?facet.field=format&rows=0&facet.sort=index
  # via stanford-mods gem
  # @return [Array<String>] value(s) in the SearchWorks controlled vocabulary, or []
  def format
    vals = @modsxml.format
    if vals.empty?
      puts "#{@druid} has no SearchWorks format from MODS - check <typeOfResource> and other implicated MODS elements"
    end
    vals
  end

  # call stanford-mods format_main to get results
  # @return [Array<String>] value(s) in the SearchWorks controlled vocabulary, or []
  def format_main_ssim
    vals = @modsxml.format_main
    if vals.empty?
      puts "#{@druid} has no SearchWorks Resource Type from MODS - check <typeOfResource> and other implicated MODS elements"
    end
    vals
  end

  # call stanford-mods sw_genre to get results
  # @return [Array<String>] value(s)
  def genre_ssim
    @modsxml.sw_genre
  end

protected

  # @return true if the string parses into an int, and if so, the int is >= 0
  def is_positive_int? str
    begin
      if str.to_i >= 0
        return true
      else
        return false
      end
    rescue
    end
    return false
  end

  # determines particular flavor of displayable publication year field
  # @return Solr field name as a symbol
  def date_type_sym
    vals = @modsxml.term_values([:origin_info,:dateIssued])
    if vals and vals.length > 0
      return :publication_year_isi
    end
    vals = @modsxml.term_values([:origin_info,:dateCreated])
    if vals and vals.length > 0
      return :creation_year_isi
    end
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
      if !@purlxml.is_collection then
        if display_type == "image"
          ids = @purlxml.image_ids
        elsif display_type == "file"
          ids = @purlxml.file_ids
        end
      end
      ids
    end
  end

  # the collection druid for items in a collection
  # @return [Array<String>] druids
  def collection
    @collection ||= begin
      coll_ids = []
      @collection_data.keys.each do | cdruid |
        if @collection_data[cdruid][:ckey].nil? then
          coll_ids.push cdruid
        else
          coll_ids.push @collection_data[cdruid][:ckey]
        end
      end
      return nil if coll_ids.empty?
      coll_ids
    end
  end

  # The collection druid or catkey and collection title for items in a collection
  # for display in SearchWorks
  # @return [Array<String>] druid/catkey -|- title
  def collection_with_title
    @collection_with_title ||= begin
     coll_title = []
     @collection_data.keys.each do | cdruid |
        if @collection_data[cdruid][:ckey].nil? then
          coll_title.push "#{cdruid}-|-#{@collection_data[cdruid][:label]}"
        else
          coll_title.push "#{@collection_data[cdruid][:ckey]}-|-#{@collection_data[cdruid][:label]}"
        end
      end
      return nil if coll_title.empty?
      coll_title
    end
  end
end
