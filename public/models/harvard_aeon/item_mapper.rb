require 'securerandom'

module HarvardAeon
  class ItemMapper < RequestListItemMapper

    include ManipulateNode

    def with_request_number(item_map)
      num = SecureRandom.hex(4)
      Hash[[['Request', num]] + item_map.map {|k,v| [k+'_'+num, v]}]
    end


    def repo_field_for(item, field)
      repo_code = item.resolved_repository['repo_code']
      if @opts.has_key?(:repo_fields)
        @opts[:repo_fields].fetch(field, repo_code)
      else
        repo_code
      end
    end


    def hollis_number_for(resource)
      resource['notes'].select {|n| n['type'] == 'processinfo' && n['label'] == 'Aleph ID'}
                       .map {|n| n['subnotes'].map {|s| s['content'].strip}}
                       .flatten.compact.join('; ')
    end


    def access_restrictions_for(item)
      item['notes'].select {|n| n['type'] == 'accessrestrict'}
                   .map {|n| n['subnotes'].map {|s| s['content']}}
                   .flatten.compact.join('; ')
    end


    def creation_date_for(item)
      item['dates'].select {|d| d['label'] == 'creation'}.map {|d| d['expression']}.join('; ')
    end


    def physical_location_for(item)
      item['notes'].select {|n| n['type'] == 'physloc'}.map {|n| n['content'].join(' ')}.join('; ')
    end


    def containers_for(item)
      (item.raw['_resolved_top_container_uri_u_sstr'] || {}).values.flatten.compact
        .map {|tc| tc['sub_containers'] = item['json']['instances']
          .select {|i| i.has_key?('sub_container') && i['sub_container'].has_key?('top_container')}
          .map {|i| i['sub_container']}.select {|sc| sc['top_container']['ref'] == tc['uri']}; tc}
    end


    def with_mapped_container(item_map, container)
      item_map.merge({
        'ItemVolume'  => container['display_string'],
        'ItemNumber'  => (container['barcode_u_sstr'] || []).first,
        'ItemIssue'   => container['sub_containers'].map {|sc| sc['indicator_2']}.compact.join('; '),
        'ItemInfo5'   => (container['location_display_string_u_sstr'] || []).join('; '),
      })
    end


    def container_barcode_for(item)
      item['instances'].select {|i| i.has_key?('sub_container') && i['sub_container'].has_key?('top_container')}
                       .map {|i| i['sub_container']['top_container']['_resolved']['barcode']}.join('; ')
    end


    def container_child_indicator_for(item)
      item['instances'].select {|i| i.has_key?('sub_container')}
                       .map {|i| i['sub_container']['indicator_2']}.join('; ')
    end


    def container_location_for(item)
      (item.raw['_resolved_top_container_uri_u_sstr'] || {}).values.map {|a| a.map {|tc| tc['location_display_string_u_sstr']}}
                                                            .flatten.join('; ')
    end

  end
end
