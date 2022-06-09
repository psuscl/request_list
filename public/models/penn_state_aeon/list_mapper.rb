module PennStateAeon
  class ListMapper < RequestListMapper

    RequestList.register_list_mapper(self, :penn_state_aeon)

    def form_fields
      {
        'SystemId'              => 'ArchivesSpaceTest',
        'ReturnLinkURL'         => AppConfig[:public_proxy_url] + '/plugin/request_list',
        'ReturnLinkSystemName'  => @opts[:return_link_label],
        'AeonForm'              => 'EADRequest',
        'WebRequestForm'        => 'DefaultRequest',
        'DocumentType'          => 'Default',
        'RequestType'           => 'Loan',
        'UserReview'            => 'Yes',
        'SkipOrderEstimate'     => '',
        'SubmitButton'          => 'Submit Request',

        'GroupRequestsByLocation'        => 'Yes',
        'GroupingIdentifier'             => 'gid',
        'GroupingOption_ItemInfo1'       => 'FirstValue',
        'GroupingOption_ItemInfo2'       => 'FirstValue',
        'GroupingOption_ItemTitle'       => 'FirstValue',
        'GroupingOption_ItemSubTitle'    => 'Concatenate',
        'GroupingOption_ItemAuthor'      => 'FirstValue',
        'GroupingOption_ItemDate'        => 'Concatenate',
        'GroupingOption_Location'        => 'FirstValue',
        'GroupingOption_CallNumber'      => 'FirstValue',
        'GroupingOption_ItemPlace'       => 'Concatenate',
        'GroupingOption_ItemIssue'       => 'Concatenate',
        'GroupingOption_ItemVolume'      => 'FirstValue',
        'GroupingOption_ItemNumber'      => 'FirstValue',
        'GroupingOption_ItemInfo5'       => 'FirstValue',
      }
    end

  end
end
