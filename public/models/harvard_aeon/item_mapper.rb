require 'securerandom'

module HarvardAeon
  class ItemMapper < RequestListItemMapper

    include ManipulateNode

    def get_request_number
      SecureRandom.hex(4)
    end


    def repo_field_for(item, field)
      repo_code = item.resolved_repository['repo_code']
      if @opts.has_key?(:repo_fields)
        @opts[:repo_fields].fetch(field, repo_code)
      else
        repo_code
      end
    end

  end
end
