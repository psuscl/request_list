require 'securerandom'

class HarvardAeonArchivalObjectMapper < RequestListItemMapper

  include ManipulateNode

  RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

  def map(item)
    num = SecureRandom.hex(4)
    {
      'Request' => num, 
      "ItemTitle_#{num}" => strip_mixed_content(item['title']),
      "Location_#{num}" => item.resolved_repository['repo_code']
    }
  end

end
