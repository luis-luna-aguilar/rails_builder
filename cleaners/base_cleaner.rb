require_relative "../file_utilities"

class BaseCleaner

  CONTROLLER_ACTIONS = %w(index new create edit update show destroy)

  def initialize(file_path, actions, controller_name, project_path)
    @file = file_path
    @actions = actions
    @controller = controller_name
    @project_path = project_path
  end

  private

    def remove_unused_files
      actions_complement.each do |action|
        delete_files_for( action )
      end
    end

    def delete_files_for( action )
      system( "cd #{@project_path} && rm app/views/#{@controller}/#{action}.html.slim" )
    end

    def cleanup_unused_actions
      actions_complement.each do |action|
        policies_hash = ACTION_REMOVAL_POLICIES[action]
        line = find_line_for(@file, "def #{action}")
        remove_file_lines(@file, (line - policies_hash[:back]), policies_hash[:lines])
      end
    end

    def actions_complement
      CONTROLLER_ACTIONS - @actions
    end

end
