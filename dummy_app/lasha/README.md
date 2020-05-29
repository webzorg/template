


# Lasha
This rails plugin aims to be a general helper gem for as many rails apps as possible.
It will to be a collection of features and helpers that most rails apps need.
Potential of this gem is endless, please fork and add more features!

## Features
#### Helpers
* [Index Table Generator](#index-table-generator)
  * With built in:
    * Pagination ([pagy](https://github.com/ddnexus/pagy))
    * Sort by Column ([ransack](https://github.com/amitdotagarwal/ransack))
* [Bootstrap 4 Styles](#bootstrap-4-styles)
* [Mailer helper](#mailer-helper)

## Usage
#### Index Table Generator
Controller `index` action
```
@data = Lasha.setup_data(
  controller: self,
  # namespace: :admin, # optional
  # model: Model,      # optional
  collection: Model.all.order(created_at: :desc),
  attributes: %i[amount node_id created_at],
  # actions: %i[show]  # optional
  # pagy_items: 20  # optional
)
```
`setup_data` input options
```
controller: (required) used to derive namespace and index actions
collection: (required) array or AR collection
attributes: (required) model attributes determine which index columns are shown
namespace-: (optional) controller namespace (derive from controller)
model-----: (optional) derive from collection
actions---: (optional) derive from controller, can contain %i[new show edit destroy]
pagy_items: (optional) items per page (default: 20)
```

index view `index.html.slim`
```
= render partial: "lasha/index_generator", locals: { data: @data }
```

#### Bootstrap 4 Styles
All the views from lasha come styled with bootstrap 4 classes, in order for them to work, you need to add bootstrap 4 to your yarn dependencies. This step is optional.

```
yarn add bootstrap@4
```
lasha handles import of `bootstrap.scss` stylesheet itself, just do the following:
insert `@import lasha_application` in your  `application.sass`

#### Mailer helper
Mail helper uses its own partial, just invoke:
```
LashaMailer.notify("destination@email.com", "subject", "body").deliver!
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "lasha"

# needed if using rails >= 6.0.2.rc2
# gem "ransack", github: "activerecord-hackery/ransack"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install lasha
```

## Dependencies
Gems marked with `*` are required within engine, so you can use these gems without even including them inside your parent app Gemfile.

* rails (5+)
* sassc-rails (*)
* slim-rails (*)
* aasm (*)
* [pagy](https://github.com/ddnexus/pagy) (*)
* [ransack](https://github.com/amitdotagarwal/ransack) (*)
* devise (*)
* rolify (*)
* devise-i18n (*)
* rails-i18n (*)
* autoprefixer-rails (*)
* redis (*)
* hiredis (*)
* sidekiq (*)
* sidekiq-cron (*)
* sidekiq-failures (*)
* sitemap_generator (*)
* image_processing (*)
* rspec-rails
* factory_bot_rails

## Development Helpers
Snippet for quickly rebuilding gem
```
cd ~/gem_dir
gem uninstall lasha; rake build; gem install pkg/lasha-0.5.0.gem;
```

## Contributing
PR will do. Also, you can contact me if you want to discuss large scale ideas.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
