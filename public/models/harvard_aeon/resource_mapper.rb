module HarvardAeon
  class ResourceMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, Resource)

    def show_button?(item)
      # only if childless
      ArchivesSpaceClient.instance.get_raw_record(item['uri'] + '/tree/root')['child_count'] == 0
    end


    def map(item)
      shared_fields = {
        'Site' => repo_field_for(item, 'Site'),
        'ItemInfo2' => hollis_number_for(item['json']),
        'ItemTitle' => strip_mixed_content(item['title']),
        'ItemAuthor' => (item.raw["creators"] || []).join('; '), 
        'ItemDate' => creation_date_for(item['json']),
        'Location' => repo_field_for(item, 'Location'),
        'SubLocation' => physical_location_for(item['json']),
        'CallNumber' => item.identifier,
        'ItemPlace' => access_restrictions_for(item['json']),
      }

      containers = containers_for(item)
      return [with_request_number(shared_fields)] if containers.empty?

      containers.map {|c|
        with_request_number(with_mapped_container(shared_fields, c))
      }
    end

  end
end
