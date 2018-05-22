require 'securerandom'

module HarvardAeon
  class ItemMapper < RequestListItemMapper

    include ManipulateNode

    def map_extensions(mapped, item, repository, resource, resource_json)
      mapped.ext(:site).name = repo_field_for(repository, 'Site')
      mapped.ext(:location).name = repo_field_for(repository, 'Location')
      mapped.ext(:hollis).id = hollis_number_for(resource_json)
      mapped.ext(:physical_location).name = physical_location_for(item.class == Container ? resource_json : item['json'])
      mapped.ext(:access_restrictions).name = process_mixed_content(access_restrictions_for(resource_json))

      containers_for(item).map do |c|
        mapped.container.multi.select {|m| m.uri == c['uri']}.map do |m|
          m.ext(:indicator, (c['sub_containers'] || []).map {|sc| sc['indicator_2']}.compact.join('; '))
          m.ext(:location, (c['location_display_string_u_sstr'] || []).join('; '))
        end
      end
    end


    def with_request_number(item_map)
      num = SecureRandom.hex(4)
      Hash[[['Request', num]] + without_unneeded_fields(item_map).map {|k,v| [k+'_'+num, v]}]
    end


    def without_unneeded_fields(map)
      map.delete_if {|k, v| !v || v.strip.empty?} # empty values
    end


    def repo_field_for(repository, field)
      repo_code = repository['repo_code']
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


    def physical_location_for(item)
      item['notes'].select {|n| n['type'] == 'physloc'}.map {|n| n['content'].join(' ')}.join('; ')
    end


    def containers_for(item)
      (item.raw['_resolved_top_container_uri_u_sstr'] || {}).values.flatten.compact
        .map {|tc| tc['sub_containers'] = item['json']['instances']
          .select {|i| i.has_key?('sub_container') && i['sub_container'].has_key?('top_container')}
          .map {|i| i['sub_container']}.select {|sc| sc['top_container']['ref'] == tc['uri']}; tc}
    end


    def with_mapped_container(mapped, item_map, container)
      item_map.merge({
        'ItemVolume'  => container.name.gsub(/ \[\d+\]/, ''),
        'ItemNumber'  => container.id,
        'ItemIssue'   => [mapped.record.id, container.ext(:indicator)].compact.select{|i| !i.empty?}.join(': '),
        'ItemInfo5'   => container.ext(:location)
      })
    end
  end
end
