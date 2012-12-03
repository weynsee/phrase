require 'optparse'

class OptionFactory
  def self.options_for(command, options)
    OptionParser.new do |opts|
      self.send(command, opts, options[command])
    end
  end

  def self.init(opts, set)
    opts.on("--secret=YOUR_AUTH_TOKEN", String, "Your auth token") do |secret|
      set[:secret] = secret
    end
    
    opts.on("--default-locale=en", String, "The default locale for your application") do |default_locale|
      set[:default_locale] = default_locale
    end
  end
  private_class_method :init

  def self.push(opts, set)
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
  private_class_method :push

  def self.pull(opts, set)
    opts.on("--format=yml", String, "See documentation for list of allowed locales") do |format|
      set[:format] = format
    end
    
    opts.on("--target=./phrase/locales", String, "Target folder to store locale files") do |target|
      set[:target] = target
    end
  end
  private_class_method :pull
  
  def self.default(opts, set)
    opts.on_tail("-v", "--version", "Show version number") do |version|
     set[:version] = true
    end
    
    opts.on_tail("-h", "--help", "Show help") do |help|
      set[:help] = true
    end
  end
  private_class_method :default
end
