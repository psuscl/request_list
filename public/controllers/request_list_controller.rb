class RequestListController <  ApplicationController
  def index
    @results = archivesspace.search_records(JSON.parse(cookies['as_pui_request_list_list_contents']), {})
  end
end
