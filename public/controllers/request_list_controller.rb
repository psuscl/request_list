class RequestListController <  ApplicationController
  def index

    uris = JSON.parse((cookies['as_pui_request_list_list_contents'] || '[]'))

    flash.now[:success] = I18n.t('plugin.request_list.sent_items_message', {:sent => params[:sent]}) if params[:sent]

    if uris.empty?
      return render 'request_list/empty_list'
    end

    results = archivesspace.search_records(uris, {'resolve[]' => ['repository:id',
                                                                  'resource:id',
                                                                  'top_container_uri_u_sstr:id',
                                                                  'collection_uri_u_sstr:id',
                                                                  'ancestors:id@compact_resource',
                                                                 ]})
    @mapper = RequestList.new(results.records)

    excluded = {}
    AppConfig[:request_list][:repositories].each do |k,v|
      next if k == :default
      next unless @mapper.repos.has_key?(k)
      ((v[:item_opts] || {})[:excluded_request_types] || []).each do |rt|
        excluded[rt] ||= {}
        excluded[rt][k] = I18n.t('plugin.request_list.excluded_items_message',
                                 {:request_type => rt, :repo => @mapper.repos[k]})
      end
    end
    @excluded = excluded.to_json

  end
end
