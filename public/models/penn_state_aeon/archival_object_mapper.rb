module PennStateAeon
  class ArchivalObjectMapper < ItemMapper

    RequestList.register_item_mapper(self, :penn_state_aeon, ArchivalObject)

    def request_permitted?(item)
      # only if not a series or sub-series
      !['series', 'subseries'].include?(item['level'])
    end
    
    def map_extensions(mapped, item, repository, resource, resource_json)
      super
      mapped.ext(:level).name = item['level'].capitalize
      mapped.record.ext(:dao_location, dao_location_for(item['json']))
    end


    def dao_location_for(item)
      (item['instances'] || []).select{|i| i['instance_type'] == "digital_object"}
        .map{|d| d['digital_object']['_resolved']}
        .select{|d| d.has_key?('user_defined') && d['user_defined']['enum_1'] == "preservation"}
        .map{|d| "https://arks.libraries.psu.edu/#{d['digital_object_id']}"}
        .join('; ')
    end


    def form_fields(mapped)
      shared_fields = {
        'ItemTitle'      => mapped.collection.name,
        'ItemSubTitle'   => mapped.record.name,
        'ItemAuthor'     => mapped.creator.name,
        'ItemDate'       => mapped.date.name,
        'CallNumber'     => mapped.collection.id,
        'ItemInfo1'      => mapped.collection.ext(:access_restrictions),
        'ItemIssue'      => mapped.record.id,
        'SubLocation'    => mapped.record.ext(:dao_location),
      }

      return [as_aeon_request(shared_fields)] unless mapped.container.has_multi?

      mapped.container.multi.map {|c|
        as_aeon_request(with_mapped_container(mapped, shared_fields, c))
      }
    end

  end
end
