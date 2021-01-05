# Template

## What does this project do
The primary idea of this project is to leverage Rails template feature in order to jumpstart project with useful defaults. The project created by this template will include [lasha engine](https://github.com/webzorg/lasha/tree/master) This makes it possible to develop common core for the app separately, for a developer to be able to use it in another app in the future.

#### Install requried gems
```
gem install rails rubocop rubocop-performance
```

#### Create repo using the [Github API](https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#create-an-organization-repository)
```
curl \
  -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d '{"name":"name", "private":"true"}'
```

#### Clone the project locally
```
cd ~/; git clone --recurse-submodules git@github.com:webzorg/template.git
```

#### Create the project with the template
```
  rails new ${project_name} \
    --skip-spring \
    --skip-test \
    --database=postgresql \
    --webpacker=stimulus \
    --template=~/template/template.rb
```

#### Update rails credentials using the template
`rails credentials:edit`

```
# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base:

sendgrid_key:
# sms_office_key:

admin_mail: ""
info_mail: ""
from_email: ""

aws:
  access_key_id:
  secret_access_key:
  staging:
    bucket_name:
  production:
    bucket_name:
  region: eu-central-1

facebook:
  app_id:
  app_secret:

google:
  analytics_code:
  # api_key:
  client_id:
  client_secret:

development:
  host: "localhost:3000"
  # db_url: "postgres://user:pass@host:5432/app_development"

staging:
  host: ""
  # db_url: "postgres://user:pass@host:5432/app_development"

production:
  host: ""
  # db_url: "postgres://user:pass@host:5432/app_development"

```

### Development snippets
#### Quickly generate new project without js and bundling for speed
```
rm -rf app_name; rails new app_name -J -B; ls -alh app_name
```

## Dependencies
See [lasha engine](https://github.com/webzorg/lasha/tree/master#dependencies)'s dependencies

## Contributing
PR will do. Also, you can contact me if you want to discuss large scale ideas.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
