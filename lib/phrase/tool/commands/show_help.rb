# -*- encoding : utf-8 -*-

class Phrase::Tool::Commands::ShowHelp < Phrase::Tool::Commands::Base
  def initialize(options, args)
    super(options, args)
  end
  
  def execute!
    show_help
  end
  
private
  
  def show_help
    print_message <<USAGE
usage: phrase <command> [<args>]

  phrase init --secret=<YOUR SECRET> --default-locale=<DEFAULT LOCALE, e.g. en> --default-format=<FORMAT, e.g. yml> --default-target=<TARGET, default is ./phrase/locales/>

  phrase push FILE [--tags=<tags>] [--locale=<locale>]
  phrase push DIRECTORY [--tags=<tags>] [--locale=<locale>]

  phrase pull [LOCALE] [--target=<target-folder>] [--format=<format>] [--tag=<tag>]

  phrase tags [-l, --list]

  phrase --version
USAGE
  end
end
