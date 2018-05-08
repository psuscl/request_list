module HarvardAeon
  class ArchivalObjectMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

    def map(item)
      num = get_request_number
      resource = JSON.parse(item.resolved_resource['json'])
      {
        'Request' => num, 
        "ItemInfo2_#{num}" => hollis_number_for(resource),
        "ItemTitle_#{num}" => strip_mixed_content(resource['title']),
        "SubItemTitle_#{num}" => strip_mixed_content(item['title']),
        "ItemAuthor_#{num}" => (item.resolved_resource["creators"] || []).join('; '), 
        "ItemDate_#{num}" => creation_date_for(item['json']),
        "Location_#{num}" => repo_field_for(item, 'Location'),
        "Site_#{num}" => repo_field_for(item, 'Site'),
      }
    end

  end
end
