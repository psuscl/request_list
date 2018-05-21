
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


## Customization

__This is not currently accurate - the mapping code is being refactored. I'll update this when done.__

In the example config you will see the entry `:harvard_test_aeon` under `:request_handlers` has
a `:profile` property with a value of `:harvard_aeon`.

The plugin ships with only this profile, but you can add new profiles from your own plugin - just
be sure to list it after this one in your `AppConfig[:plugins]` list.

A handler's profile determines the mapping classes and form templates to use for that handler.


### Mapping Classes

A profile should provide one list mapping class and one or more item mapping classes.

A list mapping class is responsible for providing a hash of inputs that will apply to the whole list
rather than for individual items.

See an example list mapper [here](https://github.com/hudmol/request_list/blob/master/public/models/harvard_aeon/list_mapper.rb).

The requirements for a list mapper class are:
  - It should subclass `RequestListMapper`
  - It should implement a `#map` method that returns a hash of input names to values
  - It should register itself for one or more profiles
      eg. `RequestList.register_list_mapper(self, :harvard_aeon)` where `:harvard_aeon` is the profile name.

An item mapping class is responsible for taking an ArchivesSpace record and mapping it to a hash of inputs
for an item in the list.

An item mapping class should subclass `RequestListItemMapper`

See an example item mapper [here](https://github.com/hudmol/request_list/blob/master/public/models/harvard_aeon/archival_object_mapper.rb).

The requirements for a item mapper class are:
  - It should subclass `RequestListItemMapper`
  - It should implement a `#map(item)` method that returns a hash of input names to values for `item`
  - It should register itself for one or more profiles
      eg. `RequestList.register_item_mapper(self, :harvard_aeon, ArchivalObject)` where `:harvard_aeon` is the profile name, and `ArchivalObject` is the record type.


### Form Templates

Templates for rendering the form that will be sent when the submit button is clicked are organized by profile.

For example, the templates for the included profile `:harvard_aeon` are placed in their own directory, see
[here](https://github.com/hudmol/request_list/tree/master/public/views/request_list/harvard_aeon).

