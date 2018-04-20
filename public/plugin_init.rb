
# check config

raise 'No config found for request_list plugin!' unless AppConfig.has_key?(:request_list)

cfg = AppConfig[:request_list]

Plugins::extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

Plugins::add_menu_item('/plugin/request_list', 'plugin.request_list.menu_label')

Plugins::add_record_page_action_js(cfg.fetch(:record_types, ['archival_object', 'accession']),
                                   'plugin.request_list.add_to_list_button_label',
                                   cfg.fetch(:icon, 'fa-indent'), 
                                   "request_list.addToList($(this).data('uri'));",
                                   cfg.fetch(:button_position, nil))

