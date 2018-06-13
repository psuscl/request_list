class RequestListItemMapper

  include ManipulateNode

  def initialize(profile, opts = {})
    @profile = profile
    @opts = opts
  end


  # override in subclass to add logic about whether requests are permitted for an item
  def request_permitted?(item)
    true
  end


  # this gets called by the handler
  # takes a PUI record (item), returns a mapped item
  def map(item)
    mapped = RequestListMappedItem.new(item['uri'], item.class)

    # precooking these because they're a little bit expensive
    # and there's a bit of logic involved, so let's just do it once
    repository = repository_for(item)
    (resource, resource_json) = resource_for(item)

    map_item(mapped, item, repository, resource, resource_json)

    map_extensions(mapped, item, repository, resource, resource_json)

    mapped.form_fields = form_fields(mapped)

    mapped
  end


  # implement in subclass
  def map_extensions(mapped, item, repository, resource, resource_json)
    # extend the mapped item by adding new fields and populating them, like this:
    # mapped.ext(:my_field).name = item['json']['user_defined']['string_1']
    # you can also change the default mappings like this:
    # mapped.creator.name = 'A God'

    # NOTE: this is the last chance to play with the PUI object (item)!
  end


  # implement in subclass
  def form_fields(mapped)
    # return a hash of input names and values using the mapped item, like this:
    # { 'ItemTitle' => mapped.record.name, ... }
    # this hash gets added to the mapped item
    {}
  end


  def map_item(mapped, item, repository, resource, resource_json)

    mapped.repository.set(repository['name'], repository['repo_code'], repository['uri'])

    mapped.collection.set(strip_mixed_content(resource['title']), resource['identifier'], resource['uri'])
    (item['_resolved_ancestors'] || {}).values.flatten.map do |a|
      mapped.collection.add.set(a['title'], (a['component_id'] || a['id_0'] && [0,1,2,3].map {|n| a["id_#{n}"]}.join('-')), a['uri'])
                           .ext(:level, a['level'].capitalize)
    end

    mapped.record.set(strip_mixed_content(item['title']), item['component_id'], item['uri'])

    containers_for(item).map do |c|
      mapped.container.add.set(c['display_string'], (c['barcode_u_sstr'] || []).first, c['uri'])
          .ext(:subs, (c['sub_containers'] || []).map {|sc| [sc['type_2'], sc['indicator_2']].compact.join(' ')}.compact.join('; '))
    end
    mapped.container.name_from_multi

    resource_json['linked_agents'].select {|a| a['role'] == 'creator'}.map do |a|
      mapped.creator.add.set(a['_resolved']['names'].select {|n| n['is_display_name']}.map {|n| n['primary_name']}.join('; '), '', a['ref'])
    end
    mapped.creator.name_from_multi

    creation_dates_for(item.class == Container ? resource_json : item['json']).map do |c|
      mapped.date.add(:name => c)
    end
    mapped.date.name_from_multi

    extents_for(item.class == Container ? resource_json : item['json']).map do |e|
      mapped.extent.add(:name => e)
    end
    mapped.extent.name_from_multi

  end


  def repository_for(item)
    item.resolved_repository
  end


  def resource_for(item)
    if item.class == Resource
      [item, item['json']]
    elsif item.class == Container
      res = item['_resolved_collection_uri_u_sstr'].values.first.first
      [res, JSON.parse(res['json'])]
    else
      [item.resolved_resource, JSON.parse(item.resolved_resource['json'])]
    end
  end


  def containers_for(item)
    return [item] if item.class == Container

    (item.raw['_resolved_top_container_uri_u_sstr'] || {}).values.flatten.compact
      .map {|tc| tc['sub_containers'] = item['json']['instances']
        .select {|i| i.has_key?('sub_container') && i['sub_container'].has_key?('top_container')}
        .map {|i| i['sub_container']}.select {|sc| sc['top_container']['ref'] == tc['uri']}; tc}
  end


  def creation_dates_for(item)
    (item['dates'] || []).select {|d| d['label'] == 'creation'}.map {|d| d['expression'] || [d['begin'], d['end']].join(' -- ')}
  end


  def extents_for(item)
    item['extents'].map{|e| e['number'] + ' ' + I18n.t("enumerations.extent_extent_type.#{e['extent_type'].gsub(' ', '_')}", default: e['extent_type'])}
  end

end
