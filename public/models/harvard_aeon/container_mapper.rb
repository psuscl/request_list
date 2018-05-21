module HarvardAeon
  class ContainerMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, Container)

    def request_permitted?(item)
      # only if only one resource
      item['json']['collection'].length < 2
    end


    def form_fields(mapped)
      [with_request_number(with_mapped_container(mapped, {
        'Site'           => mapped.ext(:site).name,
        'ItemInfo2'      => mapped.ext(:hollis).id,
        'ItemTitle'      => mapped.collection.name,
        'ItemAuthor'     => mapped.creator.name,
        'ItemDate'       => mapped.date.name,
        'Location'       => mapped.ext(:location).name,
        'SubLocation'    => mapped.ext(:physical_location).name,
        'CallNumber'     => mapped.collection.id,
        'ItemPlace'      => mapped.ext(:access_restrictions).name,
      }, mapped.container.multi.first))]
    end

  end
end
