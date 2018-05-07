module HarvardAeon
  class ContainerMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, Container)

    def show_button?(item)
      # only if only one resource
      item['json']['collection'].length < 2
    end


    def map(item)
      num = get_request_number
      {
        'Request' => num, 
        "ItemTitle_#{num}" => strip_mixed_content(item['title']),
        "Location_#{num}" => repo_field_for(item, 'Location'),
        "Site_#{num}" => repo_field_for(item, 'Site'),
      }
    end

  end
end
