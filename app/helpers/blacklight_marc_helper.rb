module BlacklightMarcHelper

  # This method should move to BlacklightMarc in Blacklight 6.x
  def refworks_export_url params = {}
    if params.is_a? ::SolrDocument or (params.nil? and instance_variable_defined? :@document)
      Deprecation.warn self, "Calling #refworks_export_url without a :url is deprecated. Pass in e.g. { url: url_for_document(@document, format: :refworks_marc_txt) } instead"
      url = url_for_document(params || @document)
      params = { url: polymorphic_url(url, format: :refworks_marc_txt, only_path: false) }
    elsif params[:id]
      Deprecation.warn self, "Calling #refworks_export_url without a :url is deprecated. Pass in e.g. { url: url_for_document(@document, format: :refworks_marc_txt) } instead"
      params = { url: polymorphic_url(url_for_document(params), format: :refworks_marc_txt, only_path: false) }
    end

    "http://www.refworks.com/express/expressimport.asp?vendor=#{CGI.escape(params[:vendor] || application_name)}&filter=#{CGI.escape(params[:filter] || "MARC Format")}&encoding=65001" + (("&url=#{CGI.escape(params[:url])}" if params[:url]) || "")
  end

  def refworks_solr_document_path opts = {}
    if opts[:id]
      refworks_export_url(url: solr_document_url(opts[:id], format: :refworks_marc_txt))
    end
  end

  # For exporting a single endnote document. (endnote_catalog_path is defined by blacklight-marc and it is used for multiple document export)
  def single_endnote_catalog_path opts = {}
    solr_document_path(opts.merge(format: 'endnote'))
  end


  # puts together a collection of documents into one refworks export string
  def render_refworks_texts(documents)
    val = ''
    documents.each do |doc|
      if doc.exports_as? :refworks_marc_txt
        val += doc.export_as(:refworks_marc_txt) + "\n"
      end
    end
    val
  end

  # puts together a collection of documents into one endnote export string
  def render_endnote_texts(documents)
    val = ''
    documents.each do |doc|
      if doc.exports_as? :endnote
        val += doc.export_as(:endnote) + "\n"
      end
    end
    val
  end
end
