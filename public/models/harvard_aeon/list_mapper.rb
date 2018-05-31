module HarvardAeon
  class ListMapper < RequestListMapper

    RequestList.register_list_mapper(self, :harvard_aeon)

    def form_fields
      {
        'SystemId'              => 'ArchivesSpace',
        'ReturnLinkURL'         => AppConfig[:public_proxy_url] + '/plugin/request_list',
        'ReturnLinkSystemName'  => @opts[:return_link_label],
        'AeonForm'              => 'EADRequest',
        'WebRequestForm'        => 'DefaultRequest',
        'DocumentType'          => 'Default',
        'RequestType'           => 'Loan',
        'UserReview'            => 'No',
        'SubmitButton'          => 'Submit Request',
      }
    end

  end
end
