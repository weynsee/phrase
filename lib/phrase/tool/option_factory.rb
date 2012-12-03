require 'optparse'
class OptionFactory
  class << self
    def init_options(options)
      set = options[:init]
      OptionParser.new do |opts|
        opts.on("--secret=YOUR_AUTH_TOKEN", String, "Your auth token") do |secret|
          set[:secret] = secret
        end
      
        opts.on("--default-locale=en", String, "The default locale for your application") do |default_locale|
          set[:default_locale] = default_locale
        end
      end
    end

    def push_options(options)
      set = options[:push]
      OptionParser.new do |opts|
        opts.on("--tags=foo,bar", Array, "List of tags for phrase push (separated by comma)") do |tags|
          set[:tags] = tags
        end
        
        opts.on("-R", "--recursive", "Push files in subfolders as well (recursively)") do |recursive|
          set[:recursive] = true
        end
        
        opts.on("--locale=en", String, "Locale of the translations your file contain (required for formats that do not include the name of the locale in the file content)") do |locale|
          set[:locale] = locale
        end
      end
    end

    def pull_options(options)
      set = options[:pull]
      OptionParser.new do |opts|
        opts.on("--format=yml", String, "See documentation for list of allowed locales") do |format|
          set[:format] = format
        end
        
        opts.on("--target=./phrase/locales", String, "Target folder to store locale files") do |target|
          set[:target] = target
        end
      end
    end
    
    def default_options(options)
      set = options[:default]
      OptionParser.new do |opts|
        opts.on_tail("-v", "--version", "Show version number") do |version|
         set[:version] = true
        end
        
        opts.on_tail("-h", "--help", "Show help") do |help|
          set[:help] = true
        end
      end
    end
  end
end
