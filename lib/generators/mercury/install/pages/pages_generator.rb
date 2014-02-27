require 'rails/generators/active_record'
module Mercury
  module Generators
    module Install
      class PagesGenerator < Rails::Generators::Base
        include Rails::Generators::Migration
        source_root File.expand_path("../templates", __FILE__)

        desc "Installs page migration and model for database backend."

        def copy_models
          copy_file 'ar_page.rb', 'app/models/mercury/page.rb'
          migration_template 'ar_page_migration.rb', 'db/migrate/create_mercury_pages.rb'
        end

        def copy_controller
          template 'pages_controller.rb', 'app/controllers/mercury/pages_controller.rb'
        end

        def add_routes
          route %Q{  namespace :mercury do
      resources :pages
    end}
        end

        # Implement the required interface for Rails::Generators::Migration.
        def self.next_migration_number(dirname) #:nodoc:
          ActiveRecord::Generators::Base.next_migration_number(dirname)
        end
      end
    end
  end
end
