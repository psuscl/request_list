require 'securerandom'
require 'json'

module PennStateAeon
  class ItemMapper < RequestListItemMapper

    include ManipulateNode

    def map_extensions(mapped, item, repository, resource, resource_json)
      mapped.record.name = mapped.record.name.split(',').uniq.join(',')
      mapped.ext(:physical_location).name = physical_location_for(item.class == Container ? resource_json : item)
      mapped.collection.ext(:access_restrictions, access_restrictions_for(resource_json))
      mapped.record.ext(:access_restrictions, access_restrictions_for(item['json']))

      (item.class == Container ? resource_json : item['json'])['extents'].zip(mapped.extent.multi) do |e, me|
        me.ext(:container_summary, e['container_summary'])
        me.ext(:physical_details, e['physical_details'])
      end
      mapped.extent.ext(:container_summary, mapped.extent.multi.map {|e| e.ext(:container_summary)}.compact.join('; '))
      mapped.extent.ext(:physical_details, mapped.extent.multi.map {|e| e.ext(:physical_details)}.compact.join('; '))


      containers_for(item).map do |c|
        mapped.container.multi.select {|m| m.uri == c['uri']}.map do |m|
          m.name = m.name.sub(/: .*$/, '')
          m.ext(:indicator, (c['sub_containers'] || []).map {|sc| sc['indicator_2']}.compact.join('; '))

          # just use the ILS Holding ID field to group by locations
          # (they're not always unique so we can't use the barcode field)
          m.ext(:location, JSON.parse(c['json'])['ils_holding_id'])
        end
      end

      (@opts[:excluded_request_types] || []).map do |t|
        mapped.ext(:excluded_request_types).add.name = t
      end

      mapped.scrub! {|v| strip_mixed_content(v) }
    end


    def as_aeon_request(item_map)
      num = SecureRandom.hex(4)
      Hash[[['Request', num]] + without_unneeded_fields(item_map).map {|k,v| [k+'_'+num, v[0,255]]}]
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


    def access_restrictions_for(item)
      (item['notes'] || []).select {|n| n['type'] == 'accessrestrict' && !n.key?('_inherited')}
                   .map {|n| n['subnotes'].map {|s| s['content']}}
                   .flatten.compact.join('; ')
    end


    def physical_location_for(item)
      if item.is_a? Hash
        # Containers just give you the resource JSON, will never have ancestors because you can't nest resources
        item_json = item
        ancestor_notes = []
      else
        # Otherwise you have the item, get resolved ancestors
        item_json = item['json']
        ancestor_notes = (item.raw.dig('_resolved_ancestors') || {}).values.flatten.map {|ancestor| ancestor['notes']}.flatten
      end

      (item_json['notes'] + ancestor_notes).select {|n| n && n['type'] == 'physloc' && !n.key?('_inherited')}.map {|n| n['content'].join(' ')}.join('; ')
    end


    def with_mapped_container(mapped, item_fields, container)
      item_fields.merge({
        'gid'         => container.ext(:location) ? container.ext(:location) + ": " + container.name : "",
        'ItemVolume'  => container.name.sub(/: .*$/, ''),
        'ItemNumber'  => container.id,
        'ItemIssue'   => [mapped.record.id, container.ext(:subs)].compact.select{|i| !i.empty?}.join(': '),
        'Location'    => container.ext(:location)
      })
    end
  end
end
