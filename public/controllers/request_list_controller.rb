class RequestListController <  ApplicationController
  def index

    uris = JSON.parse((cookies['as_pui_request_list_list_contents'] || '[]'))

    if uris.empty?
      flash.now[:success] = I18n.t('plugin.request_list.sent_items_message', {:sent => params[:sent]}) if params[:sent]
      return render 'request_list/empty_list'
    end

    results = archivesspace.search_records(uris, {'resolve[]' => ['repository:id',
                                                                  'resource:id',
                                                                  'top_container_uri_u_sstr:id',
                                                                  'collection_uri_u_sstr:id',
                                                                  'ancestors:id@compact_resource',
                                                                 ]})
    @mapper = RequestList.new(results.records)
  end
end
