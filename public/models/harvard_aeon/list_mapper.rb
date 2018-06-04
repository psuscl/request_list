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

        'GroupRequestsByLocation'       => 'Yes',
        'GroupingIdentifier'            => 'gid',
        'GroupingOption_Site'           => 'FirstValue',
        'GroupingOption_ItemInfo2'      => 'FirstValue',
        'GroupingOption_ItemTitle'      => 'FirstValue',
        'GroupingOption_ItemSubTitle'   => 'Concatenate',
        'GroupingOption_ItemAuthor'     => 'FirstValue',
        'GroupingOption_ItemDate'       => 'Concatenate',
        'GroupingOption_Location'       => 'FirstValue',
        'GroupingOption_SubLocation'    => 'FirstValue',
        'GroupingOption_ItemInfo3'      => 'FirstValue',
        'GroupingOption_CallNumber'     => 'FirstValue',
        'GroupingOption_ItemPlace'      => 'FirstValue',
        'GroupingOption_ItemIssue'      => 'Concatenate',
        'GroupingOption_ItemVolume'     => 'FirstValue',
        'GroupingOption_ItemNumber'     => 'FirstValue',
        'GroupingOption_ItemIssue'      => 'FirstValue',
        'GroupingOption_ItemInfo5'      => 'FirstValue',
      }
    end

  end
end
