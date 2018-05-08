module HarvardAeon
  class ResourceMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, Resource)

    def show_button?(item)
      # only if childless
      ArchivesSpaceClient.instance.get_raw_record(item['uri'] + '/tree/root')['child_count'] == 0
    end


    def map(item)
      num = get_request_number
      {
        'Request' => num,
        "ItemInfo2_#{num}" => hollis_number_for(item['json']),
        "ItemTitle_#{num}" => strip_mixed_content(item['title']),
        "ItemAuthor_#{num}" => (item.raw["creators"] || []).join('; '), 
        "ItemDate_#{num}" => creation_date_for(item['json']),
        "Location_#{num}" => repo_field_for(item, 'Location'),
        "Site_#{num}" => repo_field_for(item, 'Site'),
      }
    end

  end
end
