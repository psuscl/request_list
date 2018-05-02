
# Request List

An ArchivesSpace plugin that allows sending lists of records to an external request system.

Developed by Hudson Molonglo for Harvard University.

... under development.

## Configuration

Example:

```ruby
AppConfig[:request_list] = {
  :button_position => 0,
  :record_types => ['archival_object', 'resource', 'top_container'],
  :item_limit => 20,

  :request_handlers => {
    :harvard_test_aeon => {
      :name => 'Harvard Test Aeon',
      :profile => :harvard_aeon,
      :url => 'https://somewhere.at.harvard.edu/aeon.dll?action=11&type=200'
    }
  },

  :repositories => {
    :default => {
      :handler => :harvard_test_aeon,
      :opts => {
        :return_link_label => 'Return to HOLLIS'
      }
    }
  }
}

AppConfig[:pui_page_actions_request] = false
```
