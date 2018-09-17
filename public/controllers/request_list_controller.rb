class RequestListController <  ApplicationController
  def index
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


  def email
    if !params[:user_email].blank? && params[:user_email].match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      flash[:notice] = I18n.t('plugin.request_list.email.sent_message', {:email => params[:user_email]})

      RequestListMailer.email(params[:user_email], mapper).deliver

      redirect_back(fallback_location: request[:request_uri]) and return
    else
      flash[:error] = I18n.t('plugin.request_list.email.error_message', {:email => params[:user_email]})
      redirect_back(fallback_location: request[:request_uri]) and return
    end
  end


  private


  def uris
    @uris ||= JSON.parse((cookies['as_pui_request_list_list_contents'] || '[]'))
  end


  def mapper
    @mapper ||= RequestList.new(archivesspace.search_records(uris, {'resolve[]' => ['repository:id',
                                                                                    'resource:id',
                                                                                    'top_container_uri_u_sstr:id',
                                                                                    'collection_uri_u_sstr:id',
                                                                                    'ancestors:id@compact_resource',
                                                                                   ]}).records)
  end
end
