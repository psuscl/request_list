module HarvardAeon
  class ArchivalObjectMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

    def map(item)
      resource = JSON.parse(item.resolved_resource['json'])

      request_number_for({
        'ItemInfo2' => hollis_number_for(resource),
        'ItemTitle' => strip_mixed_content(resource['title']),
        'SubItemTitle' => strip_mixed_content(item['title']),
        'ItemAuthor' => (item.resolved_resource["creators"] || []).join('; '), 
        'ItemDate' => creation_date_for(item['json']),
        'Location' => repo_field_for(item, 'Location'),
        'Site' => repo_field_for(item, 'Site'),
      })
    end

  end
end
