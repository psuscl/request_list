class RequestListController <  ApplicationController
  def index

    @list = JSON.parse(cookies['as_pui_request_list_list_contents']);

    puts "CCCCCCCC #{@list.inspect}"
  end
end
