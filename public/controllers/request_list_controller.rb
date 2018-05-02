class RequestListController <  ApplicationController
  def index

    uris = JSON.parse(cookies['as_pui_request_list_list_contents'])

    if uris.empty?
      return render 'request_list/empty_list'
    end

    results = archivesspace.search_records(uris)

    @mapper = RequestList.new(results.records)

  end
end
