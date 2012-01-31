module SortableHelper
  # Helper method to generate a sortable table in the view
  # 
  # usage: <%= sortable_table(optional_params) %>
  # 
  # optional_params:
  # 
  # :paginate - Whether or not to display pagination links for the table. Default is true.
  # :partial - Name of the partial containing the table to display. Default is the table partial in the sortable
  #            plugin: 'sortable/table'
  #            
  #            If you choose to create your own partial in place of the one distributed with the sortable plugin 
  #            your partial has the following available to it for generating the table:
  #              @headings contains the table heading values
  #              @objects contains the collection of objects to be displayed in the table
  #              
  # :search - Whether or not to include a search field for the table. Default is true.
  # :extra - An array of extra content that is added to each row. e.g. a link that you'd like to appear on each object.
  #          Note: Each entry in the array must be a partial. The partial has access to the row "object" via the
  #                local variable named "object".

  def sortable_table(options={})
    paginate = options[:paginate].nil? ? true : options[:paginate]
    partial = options[:partial].nil? ? 'sortable/table' : options[:partial]  
    search = options[:search].nil? ? true : options[:search]
    extra_cell_content = options[:extra].nil? ? '' : options[:extra]
    filter = options[:filter].nil? ? '' : options[:filter]

    result = render(:partial => partial, :locals => {:search => search, :extra => extra_cell_content, :filter => filter})
    result += will_paginate(@objects).to_s if paginate
    result
  end
 
    
  def sort_td_class_helper(param)
    result = 'sortup' if params[:sort] == param
    result = 'sortdown' if params[:sort] == param + "_reverse"
    result = @sortclass if @default_sort && @default_sort == param    
    return result
  end


  def sort_link_helper(action, text, param, params, secondary, extra_params={})
    if @sort_map[param]
      options = build_url_params(action, param, params, secondary, extra_params)
      html_options = {:title => "Sort by this field"}

      link_to(text, options, html_options)
    else
      text
    end
  end

  def build_url_params(action, param, params, secondary, extra_params={})
    key = param
    if @default_sort_key && @default_sort == param
      key = @default_sort_key
    else
      key += "_reverse" if params[:sort] == param || params[:secondary_sort] == param
    end

    extra_params.merge!({:letter => params[:letter]}) if params[:letter]
    if secondary
      params = {:sort => params[:sort],
        :secondary_sort => key,
        :page => nil, # when sorting we start over on page 1
        :q => params[:q]}
    else
      params = {:sort => key,
        :secondary_sort => params[:secondary_sort],
        :page => nil, # when sorting we start over on page 1
        :q => params[:q]}
    end
    params.merge!(extra_params)

    return {:action => action, :params => params}
  end

   def row_cell_link(new_location)
     mouseover_pointer + "onclick='window.location=\"#{new_location}\"'"
   end

   def mouseover_pointer
     "onmouseover='this.style.cursor = \"pointer\"' onmouseout='this.style.cursor=\"auto\"'"
   end

   def table_header(prefix_columns="")
     result = "<tr class='tableHeaderRow'>"
     result += prefix_columns
     @headings.each do |heading|
       sort_class = sort_td_class_helper heading[1]
       result += "<td"
       result += " class='#{sort_class}'" if !sort_class.blank?
       result += ">"
       result += sort_link_helper @action, heading[0], heading[1], params, false
       result += " | "
       result += sort_link_helper @action, heading[0], heading[1], params, true
       result += "</td>"
     end
   	 result += "</tr>"
   	 return result
   end
   
   # use this helper to build a row for a set of related objects and display them and their properties in a list
   def build_display_relations_sub_row(relations_collection, display_prop)
      result = "<tr><td colspan='10'><ul>"
      relations_collection.each do |t|
         result += "<li> <a href='#' onClick='Element.toggle(\"#{dom_id(t)}view\"); toggle_collapse(this); return false;' 	
                        class='collapse' >#{t.send(display_prop)}</a>
              <div id='#{dom_id(t)}view' style='display: none;' class='contact_view'>"
                t.attributes.each do |a|
                  result +=     "#{a[0]} : #{a[1]}<br/>"
                end
          result +=             "</div>	</li>"             
   		  end
   		  result += "</ul></td></tr>" 		
        return result
   end

   def letter_search(params)
     letter_selected = params[:letter]
     result = '<ul class="alphabetical fl">'
     "A".upto("Z") do |alpha|
       result += letter_selected.eql?(alpha) ? '<li class="active">'+link_to(alpha, apply_sort(alpha,params))+'</li>' : '<li>'+link_to(alpha, apply_sort(alpha,params))+'</li>'
     end
     result += '</ul>'
   end

   def apply_sort(alpha,params)
#      params = {:sort => params[:sort],
#        :secondary_sort => params[:secondary_sort],
#        :page => nil, # when sorting we start over on page 1
#        :q => params[:q],
#        :letter => alpha
#        }
      params.merge!(:letter => alpha)
   end

end
