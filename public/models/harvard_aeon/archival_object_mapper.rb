module HarvardAeon
  class ArchivalObjectMapper < ItemMapper

    RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

    def map_extensions(mapped, item, repository, resource, resource_json)
      super
      mapped.ext(:level_and_extent).name = [item['level'].capitalize, mapped.extent.name].join(': ')
    end


    def form_fields(mapped)
      shared_fields = {
        'Site'           => mapped.ext(:site).name,
        'ItemInfo2'      => mapped.ext(:hollis).id,
        'ItemTitle'      => mapped.collection.name,
        'ItemSubTitle'   => mapped.record.name,
        'ItemAuthor'     => mapped.creator.name,
        'ItemDate'       => mapped.date.name,
        'Location'       => mapped.ext(:location).name,
        'SubLocation'    => mapped.ext(:physical_location).name,
        'ItemInfo3'      => mapped.ext(:level_and_extent).name,
        'CallNumber'     => mapped.collection.id,
        'ItemPlace'      => mapped.ext(:access_restrictions).name,
        'ItemIssue'      => mapped.record.id,
      }

      return [with_request_number(shared_fields)] unless mapped.container.has_multi?

      mapped.container.multi.map {|c|
        with_request_number(with_mapped_container(mapped, shared_fields, c))
      }
    end

  end
end
