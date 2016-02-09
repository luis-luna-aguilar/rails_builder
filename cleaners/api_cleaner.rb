require_relative "../file_utilities"

class ApiCleaner

  JSON_LINES_TO_REMOVE = [5,10,23,26,28,30,31,34,35,37,39,40,43,45,46,46]

  ACTION_REMOVAL_POLICIES = {
    "index" => { back: 1, lines: 5 },
    "show" => { back: 1, lines: 4 },
    "new" => { back: 1, lines: 5 },
    "edit" => { back: 1, lines: 4 },
    "create" => { back: 1, lines: 11 },
    "update" => { back: 1, lines: 9 },
    "destroy" => { back: 1, lines: 6 }
  }

  def initialize(file_path, actions, controller_name)
    @file = file_path
    @actions = actions
    @controller = controller_name
  end

  def run
    cleanup_json_api_lines
    replace_api_texts
    # cleanup_unused_actions
    # remove_unused_files
  end

  private

    def cleanup_unused_actions
      ACTION_REMOVAL_POLICIES.each do |action, policies_hash|
        line = find_line_for("def #{action}")
        remove_file_lines( @file, (line - policies_hash[:back]), policies_hash[:lines] )
      end
    end

    def replace_api_texts
      text = File.read(@file)
      replace = gsub_cleanup(text)
      File.open(@file, "w") { |file| file.puts replace }
    end

      def gsub_cleanup(text)
        nt = text.gsub 'format.html { ', ''
        nt.gsub ' }', ''
      end

    def cleanup_json_api_lines
      JSON_LINES_TO_REMOVE.each do |line|
        remove_file_lines(@file, line, 1)
      end
    end

end
