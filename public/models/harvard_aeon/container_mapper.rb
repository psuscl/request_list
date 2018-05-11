module HarvardAeon
  class ContainerMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, Container)

    def request_permitted?(item)
      # only if only one resource
      item['json']['collection'].length < 2
    end


    def map(item)
      resolved_resource = item['_resolved_collection_uri_u_sstr'].values.first.first
      resource = JSON.parse(resolved_resource['json'])

      [with_request_number(with_mapped_container({
        'Site' => repo_field_for(item, 'Site'),
        'ItemInfo2' => hollis_number_for(resource),
        'ItemTitle' => strip_mixed_content(resource['title']),
        'ItemAuthor' => (resolved_resource["creators"] || []).join('; '),
        'ItemDate' => creation_date_for(resource),
        'Location' => repo_field_for(item, 'Location'),
        'SubLocation' => physical_location_for(resource),
        'CallNumber' => resolved_resource['identifier'],
        'ItemPlace' => access_restrictions_for(resource),
      }, item.raw))]
    end

  end
end
