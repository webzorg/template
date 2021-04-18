# frozen_string_literal: true

namespace :db do
  desc "Convert development DB to Rails test fixtures"
  task to_fixtures: :environment do
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.tables.each do |table_name|
      next if %w[ar_internal_metadata delayed_jobs schema_info schema_migrations].freeze.include?(table_name)

      counter = "000"
      file_path = "#{Rails.root}/test/fixtures/#{table_name}.yml"
      File.open(file_path, "w") do |file|
        rows = ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}")
        data = rows.each_with_object({}) do |record, hash|
          suffix = record["id"].blank? ? (counter = counter.succ) : record["id"]
          hash["#{table_name.singularize}_#{suffix}"] = record
        end
        puts "Writing table '#{table_name}' to '#{file_path}'"
        file.write(data.to_yaml)
      end
    end
  ensure
    ActiveRecord::Base.connection&.close
  end
end
