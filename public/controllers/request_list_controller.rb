class RequestListController <  ApplicationController
  def index
    list = JSON.parse(cookies['as_pui_request_list_list_contents'])
    if list.empty?
      @results = false
    else
      @results = archivesspace.search_records(list, {})
    end
  end
end
