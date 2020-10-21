class LashaModuleGenerator < Rails::Generators::NamedBase
  def create_helper_file
    create_file "lib/modules/#{file_name}.rb",
    <<~FILE
      module #{class_name}
      end
    FILE
  end
end
