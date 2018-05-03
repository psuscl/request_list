class HarvardAeonListMapper < RequestListMapper

  RequestList.register_list_mapper(self, :harvard_aeon)

  def map
    {
      'SystemId' => 'ArchivesSpace',
      'ReturnLinkURL' => (AppConfig[:public_proxy_url] || AppConfig[:public_url]) + '/plugin/request_list',
      'ReturnLinkSystemName' => @opts[:return_link_label],
      'RequestType' => 'Loan',
      'UserReview' => 'No',
    }
  end

end
