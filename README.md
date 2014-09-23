# PhraseApp #
[![Code Climate](https://codeclimate.com/github/phrase/phrase.png)](https://codeclimate.com/github/phrase/phrase)
[![Build Status](https://secure.travis-ci.org/phrase/phrase.png)](http://travis-ci.org/phrase/phrase)

PhraseApp lets you set up a professional translation process to boost the quality of your translations with the powerful In-Context Editor.

You can order professional translations from within PhraseApp, or just work with your own team. Our platform support various programming languages and frameworks. Such as [Ruby on Rails, Symfony, Zend Framework, iOS, Android and many more](https://phraseapp.com/docs/general/supported-platforms).

This client lets you integrate PhraseApp into your project and access your locale files through the PhraseApp [API](https://phraseapp.com/docs/api/overview).

[Get your free PhraseApp trial](https://phraseapp.com/signup) and start right away.

### Supported Formats ###
You can manage your locale files with PhraseApp if you use one of the following formats:

* Ruby/Rails YAML
* Gettext
* Gettext Template
* Android Strings
* iOS Localizable Strings
* XLIFF
* Qt Phrase Book
* Qt Translation Source
* Chrome JSON i18n
* Simple JSON
* Nested JSON
* i18n-node-2 JSON
* .NET ResX
* Windows Phone ResX
* Windows 8 Resource
* INI
* Java Properties .properties
* Java Properties XML
* Objective-C/Cocoa Property List
* Symfony YAML
* Symfony2 YAML (Beta)
* TMX Translation Memory eXchange
* Excel XLSX (Beta)
* CSV
* PHP Array
* Zendesk CSV
* Laravel PHP
* Angular Translate
* Mozilla Properties

## Usage

This command line client is a Ruby gem. If you haven't installed Ruby on your system yet, we have put together a [handy tutorial](https://phraseapp.com/docs/installation/ruby-installation) for you.

You don't have to use this client but can also use the [API directly](https://phraseapp.com/docs/api/overview).

### Installation

Install the gem via `gem install`

	gem install phrase
	
or add it to your `Gemfile` when using bundler:

	gem 'phrase'

and install it	

	$ bundle install
	
That's it!

### Initialization

Before you can use the phrase command line client you have to set up some configuration data. When using Rails we recommend using the Rails generator we provide. For all other environments you can use a simple command to initialize the setup.

To initialize phrase, your project auth token (secret) is required. You can find the auth token next to the project on [your project overview](https://phraseapp.com/projects).

#### When using Rails

Install phrase by executing the Rails generator:

	bundle exec rails generate phrase:install --auth-token=<YOUR_TOKEN>
	
This will:

* create a `phrase.rb` initializer file in `./config/initializers/`
* initialize your phrase project by creating a default locale in PhraseApp
* create a `.phrase` configuration file containing the secret

*Using the generator will automatically prepare your Rails application for use with the [In-Context-Editor](https://phraseapp.com/features).*

#### Without Rails

You can use the `phrase init` command to initialize your project:

	phrase init --secret=<YOUR_TOKEN>
	
This will:

* initialize your phrase project by creating a default locale in PhraseApp
* create a `.phrase` configuration file containing the secret

### Pushing Locale Files

Push your localization files to PhraseApp by using the push command:

    phrase push FILE|DIRECTORY

This will push all files found in the given directory or push only the file if the given path points to a file. The path falls back to `./config/locales`, the default localization file path in Ruby on Rails applications.

* `--recursive, -R`

    To push all files in a given directory recursively you can use the `--recursive` parameter:

      phrase push </path/to/file.extension> --recursive

* `--tags`

    Attach one or multiple tags with your file upload. All keys added by the push will be tagged with the specified tags:

      phrase push --tags=foo,bar

* `--locale`

	Some formats do not contain information about their content's locale. These formats (e.g. Java Properties) require you to specify the locale (name) with the push command:
	
	  phrase push messages.properties --locale=en

* `--format`

	Specify the format of the files you want to push. We usually try to guess it by evaluating the file name but sometimes you need to tell us more:
	
	  phrase push messages.json --format=simple_json
	
	For a full list of all supported formats check our [format guide](https://phraseapp.com/docs/format-guide/overview).
	
* `--force-update-translations`

	When pushing files to PhraseApp, we only add new resources (keys and translations) by default. Use this flag if you want to override existing translations as well. 
	
	  phrase push most-recent.yml --force-update-translations
	
	Please note that we do not delete resources from your project even when using this option. Still you have to make sure that your file contains the most recent translations since all translations in your project will be updated with the file content!

* `--skip-unverification`

	When using the `--force-update-translations` flag (see above) we will automatically unverify updated translations if configured in your workflow. Use this flag to prevent all translations being unverified. This option is great if you have copy&replaced strings in your file and just want to update all translations:
	
	  phrase push most-recent.yml --force-update-translations --skip-unverification

* `--skip-upload-tags`

	When you push translations we will automatically attach new keys to an upload tag. To prevent this from happening, you can use this option:
	
	  phrase push my-file.yml --skip-upload-tags
	  
	This can be very useful if you replace your content very often and do not want to create hundreds of upload-tags.
	
* `--convert-emoji`

	When you use Emoji symbols in your locale files (i.e. in iOS Localizable strings files) you can tell us to convert them to more readable symbols:
	
	  phrase push Localizable.strings --convert-emoji
	
	Please note that you should only use this option if your file definitely contains Emoji symbols since it slows down the upload time quite a bit.

* `--secret`

	Your project auth token. You can find the auth token in your project overview or project settings form. This will fall back to the token stored in your `.phrase` config file.

### Pulling Locale files

Pull your most recent locale files by using the `pull` command:

    phrase pull

This will pull localization files for all of your locales available in the current project. Files are by default stored at `./phrase/locales` in YAML format.

* `--format`

	Specify the format you want to download your files in:
	
	  phrase pull en --format=simple_json
	
	For a full list of all supported formats check our [format guide](https://phraseapp.com/docs/format-guide/overview).

* `--target`

	Specify where you want to download the files to:
	
	  phrase pull fr --target="./config/locales"
		
	By default, files will be downloaded to `./phrase/locales`.
	
* `--tag`
	
	Limit results to a given tag instead of downloading all translations:
	
	  phrase pull de --tag=feature-messenger-v2
	  
* `--updated-since`

	Limit results to translations being updated after the given date and time (UTC) in the format `YYYYMMDDHHMMSS`:
	
	  phrase pull en --updated-since=20140601123000

* `--include-empty-translations`

	By default we will only return translated keys in the file. Use this flag to include empty translations as well:
	
	  phrase pull en --include-empty-translations

* `--convert-emoji`

	When you use Emoji symbols in your translations you can tell us to convert them back to correctly encoded symbols:
	
	  phrase pull --convert-emoji
	
	Please note that you should only use this option if your translations definitely contains Emojis since it slows down the download time a bit.

* `--secret`

	Your project auth token. You can find the auth token in your project overview or project settings form. This will fall back to the token stored in your `.phrase` config file.
	
### Advanced configuration

The `phrase init` command allows several advanced configuration options to further customize the setup:

* `--default-locale`

	You can specify a locale that should be used as the default locale when setting up your PhraseApp project (default is `en`).
	
	  phrase init --secret=<YOUR_TOKEN> --default-locale=fr

* `--default-format`

	Specify a format that should be used as the default format when downloading files (default is `yml`). For a full list of all supported formats check our [format guide](https://phraseapp.com/docs/format-guide/overview).
        
* `--domain`

	Set a domain for use with Gettext translation files (default is `phrase`).
	
* `--locale-directory`

	Set the directory that contains your source locales (used by the `phrase push` command). Allows [placeholders](#allowed-placeholders).
	
* `--locale-filename`

	Set the filename for files you download from PhraseApp via `phrase pull`. Allows [placeholders](#allowed-placeholders).
	
* `--default-target`

	Set the target directly to store your localization files retrieved by `phrase pull`. Allows [placeholders](#allowed-placeholders).
	
These options will be stored in your `.phrase` config file where you can edit them later on as well.

<h3 id="allowed-placeholders">Allowed placeholders for advanced configuration</h4>

Some advanced configuration options support placeholders. These will be replaced with the actual content. This allows you to create more flexible path and filename settings.

| Placeholder     | Description            | Default |
| --------------- | ---------------------- | ------- |
| \<domain\>      | Name of the domain     | phrase  |
| \<format\>      | Format name/identifier | yml     |
| \<locale\>      | Locale name            | en      |
| \<locale.name\> | Locale name            | en      |
| \<locale.code\> | Locale code            | -       |

For example you can specify a different file name for files you retrieve via the `phrase pull` command:

    phrase init --secret=<YOUR_TOKEN> --locale-filename="<locale.name>.yml"

## Further Information
* [Read the PhraseApp documentation](https://phraseapp.com/docs)
* [Get your free PhraseApp trial](https://phraseapp.com/signup)
* [Get in touch with the engineers](https://phraseapp.com/contact)

## References
* [PhraseApp In-Context Editor](http://demo.phraseapp.com)
* [PhraseApp API](https://phraseapp.com/docs/api/overview)

## Partner-Integrations
* [PhraseApp and Ruby Motion](https://github.com/phrase/motion-phrase)
* [Heroku Add-on](https://addons.heroku.com/phrase)
* [Cloudcontrol Add-on](https://phraseapp.com/docs/cloudcontrol/introduction)
