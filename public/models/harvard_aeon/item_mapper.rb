require 'securerandom'

module HarvardAeon
  class ItemMapper < RequestListItemMapper

    include ManipulateNode

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


    def creation_date_for(item)
      item['dates'].select {|d| d['label'] == 'creation'}.map {|d| d['expression']}.join('; ')
    end


    def request_number_for(item_map)
      num = SecureRandom.hex(4)
      Hash[[['Request', num]] + item_map.map {|k,v| [k+'_'+num, v]}]
    end

  end
end
