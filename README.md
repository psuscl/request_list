
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
      :url => 'https://somewhere.at.harvard.edu/aeon.dll?action=11&type=200',
      :list_opts => {
        :return_link_label => 'Return to HOLLIS',
        :request_types => {
          'Reading room' => {
            'RequestType' => 'Loan',
            'UserReview' => 'No'
          },
          'Saved' => {
            'RequestType' => 'Loan',
            'UserReview' => 'Yes'
          },
          'Photoduplication' => {
            'RequestType' => 'Copy',
            'UserReview' => 'No'
          }
        },
        :format_options => [
                            'Digital Prints',
                            'Existing Digital Images',
                            'Microfilm',
                            'Standard Digital Photography',
                            'Studio Digital Photography'
                           ],
        :delivery_options => [
                              'Campus Pickup',
                              'Mail',
                              'Online Delivery'
                             ]
      }
    }
  },

  :repositories => {
    :default => {
      :handler => :harvard_test_aeon,
      :opts => {
        :return_link_label => 'Return to HOLLIS'
      }
    },
    'aaa' => {
      :handler => :none
    },
    'bbb' => {
      :handler => :harvard_test_aeon,
      :item_opts => {
        :repo_fields => {
          'Location' => 'BBA',
          'Site' => 'BBC'
        }
      }
    }
  }
}

AppConfig[:pui_page_actions_request] = false
```
