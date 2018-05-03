class HarvardAeonArchivalObjectMapper < RequestListItemMapper

  include HarvardCommon
  include ManipulateNode

  RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)

  def map(item)
    num = get_request_number
    {
      'Request' => num, 
      "ItemTitle_#{num}" => strip_mixed_content(item['title']),
      "Location_#{num}" => repo_field_for(item, 'Location'),
      "Site_#{num}" => repo_field_for(item, 'Site'),
    }
  end

end
