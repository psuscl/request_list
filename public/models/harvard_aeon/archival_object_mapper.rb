module HarvardAeon
  class ArchivalObjectMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

    def map(item)
      resource = JSON.parse(item.resolved_resource['json'])

      with_request_number({
        'Site' => repo_field_for(item, 'Site'),
        'ItemInfo2' => hollis_number_for(resource),
        'ItemTitle' => strip_mixed_content(resource['title']),
        'SubItemTitle' => strip_mixed_content(item['title']),
        'ItemAuthor' => (item.resolved_resource["creators"] || []).join('; '), 
        'ItemDate' => creation_date_for(item['json']),
        'ItemVolume' => item.container_display.join('; '),
        'Location' => repo_field_for(item, 'Location'),
        'SubLocation' => physical_location_for(item['json']),
        'CallNumber' => item.resolved_resource['identifier'],
        'ItemNumber' => container_barcode_for(item['json']),
        'ItemIssue' => container_child_indicator_for(item['json']),
        'ItemInfo5' => container_location_for(item),
        'ItemPlace' => access_restrictions_for(resource), # actually any level - inheritance?
      })
    end

  end
end
