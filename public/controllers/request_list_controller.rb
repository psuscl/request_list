class RequestListController <  ApplicationController
  def index

    uris = JSON.parse(cookies['as_pui_request_list_list_contents'])

    if uris.empty?
      return render 'request_list/empty_list'
    end

    results = archivesspace.search_records(uris, {'resolve[]' => ['repository:id', 'resource:id', 'top_container_uri_u_sstr:id']})

    @mapper = RequestList.new(results.records)

  end
end
