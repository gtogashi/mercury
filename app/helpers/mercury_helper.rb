module MercuryHelper

  def mercury_edit_path(path = nil)
    mercury_engine.mercury_editor_path(path.nil? ? request.path.gsub(/^\/\/?(editor)?/, '') : path)
  end

  def mercury_region(id, options = {}, &block)
    options[:name] = caller.first.split(':').first.gsub(Rails.root.to_s,'') if options[:name].nil?
    options[:type] = :full if options[:type].nil?
    options[:tag] = :div if options[:tag].nil?

    #Store a page object as an instance variable to avoid multiple loading.
    @page = Page.find_or_create_by_name(options[:name]) if @page.nil?
    contents = @page.contents
    if contents.nil? or contents[id.to_sym].nil?
      if block_given?
        content = capture(&block)
      else
        content = "New content..."
      end
    else
      content = contents[id.to_sym].html_safe
    end
    content_tag(options[:tag] , content, :class => "mercury-region", :id => id, :data => {:mercury => options[:type], :save_url => pages_path(:action => :update, :id => @page)})
  end

end
