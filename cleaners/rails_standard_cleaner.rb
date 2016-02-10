require_relative "base_cleaner"

class RailsStandardCleaner < BaseCleaner

  ACTION_REMOVAL_POLICIES = {
    "index" => { back: 2, lines: 6 },
    "show" => { back: 2, lines: 5 },
    "new" => { back: 1, lines: 5 },
    "edit" => { back: 1, lines: 4 },
    "create" => { back: 2, lines: 16 },
    "update" => { back: 2, lines: 14 },
    "destroy" => { back: 2, lines: 10 }
  }

  def run
    cleanup_unused_actions
    remove_unused_files
  end

end
