class RequestListController <  ApplicationController
  def index

    uris = JSON.parse(cookies['as_pui_request_list_list_contents'])
    # this nonsense because search_records blows up on an empty list
    results = uris.empty? ? false : archivesspace.search_records(uris)

    @mapper = RequestList.new(results.records)

  end
end
