require_relative 'cleaners/api_cleaner'

class RailsBuilder

  SCAFFOLD_FLAGS = ["--no-stylesheets", "--no-assets", "--skip-routes"]
  GENERATOR_CMD = "bundle exec rails g"

  def initialize(model_spec_hash, output_path)
    @hash = model_spec_hash
    @output = output_path
    @routes_hash = {}
  end

  def run
    run_mvc_generators
    run_validations_generator
  end

  private

    def run_validations_generator
      nil
    end

    def run_mvc_generators
      @hash["models"].each do |model_hash|
        model_name = model_hash["name"].downcase
        model_fields = extract_model_fields_from(model_hash)

        controller_name = model_name.pluralize
        controller_actions = extract_controller_actions_from(model_hash)

        add_to_routing(controller_name, controller_actions)

        if is_devise_model?(model_name)
          generate_user_fields(model_fields)
        else
          generate_standard_files(model_name, model_fields, controller_name, controller_actions)
        end
      end
    end

    def generate_standard_files(model_name, model_fields, controller_name, controller_actions)
      system( model_cmd(model_name, model_fields ) )

      unless controller_actions.empty?
        system( controller_cmd(controller_name, controller_actions) )
        # Deletion of all un-used content generated by Rails
        controller_file = "#{@output}/app/controllers/#{controller_name}_controller.rb"
        clean_up_if_no_api_requested!(controller_file, controller_actions, controller_name)
      end
    end

    def clean_up_if_no_api_requested!(controller_file, controller_actions, controller_name)
      has_api = @hash["has_api"]
      unless has_api
        ApiCleaner.new(controller_file, controller_actions, controller_name).run
      end
    end

    def is_devise_model?(model_name)
      ( @hash["has_devise"] && model_name == "user" )
    end

    def generate_user_fields(model_fields)
      fields = model_fields.map {|mf| mf.split(':').first}

      user_fields = filter_devise_fields_from( fields )
      user_fields.each do |field|
        system( add_user_field_cmd( field ) )
      end
    end

    def add_to_routing(resource, actions)
      if actions.count == 7
        @routes_hash[resource] = []
      end

      unless actions.count.zero?
        @routes_hash[resource] = actions
      end
    end

    def extract_model_fields_from(model_hash)
      model_hash["fields"].map do |field_hash|
        "#{field_hash['name'].downcase}:#{field_hash['attr_type'].downcase}"
      end
    end

    def extract_controller_actions_from(model_hash)
      model_hash["actions"].map do |action_hash|
        action_hash["name"].downcase
      end
    end

    def filter_devise_fields_from(fields_array)
      devise_fields = ["email", "password", "password_confirmation", "username"]
      fields_array.select { |f| not devise_fields.include?(f) }
    end

    def model_cmd(name, fields)
      fields_str = fields.join(' ')
      "cd #{@output} && #{GENERATOR_CMD} model #{name} #{fields_str}"
    end

    def add_user_field_cmd(field)
      "cd #{@output} && bundle exec rails g migration add_#{field}_to_users #{field}"
    end

    def controller_cmd(name, actions)
      # actions_str = actions.join(' ')
      flags = SCAFFOLD_FLAGS.dup
      flags << '--no-jbuilder' unless @hash["has_api"]
      "cd #{@output} && #{GENERATOR_CMD} scaffold_controller #{name} #{flags.join(' ')}"
    end

end