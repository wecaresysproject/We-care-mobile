require 'xcodeproj'

project_path = 'Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Define flavors and their settings
flavors = {
  'development' => {
    'bundle_id_suffix' => '.dev',
    'app_name' => 'We Care Development'
  },
  'production' => {
    'bundle_id_suffix' => '',
    'app_name' => 'We Care Production'
  }
}

base_configs = ['Debug', 'Release', 'Profile']

# 1. Add xcconfig files to the project if not already present
flutter_group = project.main_group['Flutter']
unless flutter_group
  puts "Flutter group not found! Creating it."
  flutter_group = project.main_group.new_group('Flutter')
end

xcconfig_files = {}

['development', 'production'].each do |flavor|
  ['Debug', 'Release'].each do |type|
    filename = "#{type}-#{flavor}.xcconfig"
    # The path should be relative to the group's path if the group has a path,
    # or relative to the project root if the group has no path.
    # In this project, the Flutter group has no path, so we use 'Flutter/filename'.
    full_path = "Flutter/#{filename}"
    
    file_ref = flutter_group.files.find { |f| f.path == full_path }
    unless file_ref
      file_ref = flutter_group.new_file(full_path)
    end
    xcconfig_files["#{type}-#{flavor}"] = file_ref
  end
end

# Helper to duplicate configuration
def duplicate_config(project, config_list, base_name, new_name, settings_override = nil, xcconfig_ref = nil)
  new_config = config_list.build_configurations.find { |c| c.name == new_name }
  if new_config
    puts "Configuration #{new_name} already exists."
  else
    base_config = config_list.build_configurations.find { |c| c.name == base_name }
    unless base_config
      puts "Base configuration #{base_name} not found."
      return nil
    end

    new_config = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
    new_config.name = new_name
    new_config.build_settings = base_config.build_settings.clone
    config_list.build_configurations << new_config
    puts "Created configuration #{new_name}"
  end
  
  if settings_override
    settings_override.each do |key, value|
      new_config.build_settings[key] = value
    end
  end

  if xcconfig_ref
    new_config.base_configuration_reference = xcconfig_ref
    puts "Linked #{new_name} to #{xcconfig_ref.path}"
  end
  
  return new_config
end

# 2. Project Level Configurations
puts "--- Project Level Configurations ---"
flavors.each do |flavor, settings|
  base_configs.each do |base_name|
    new_name = "#{base_name}-#{flavor}"
    xcconfig_key = base_name == 'Debug' ? "Debug-#{flavor}" : "Release-#{flavor}"
    xcconfig_ref = xcconfig_files[xcconfig_key]
    duplicate_config(project, project.build_configuration_list, base_name, new_name, nil, xcconfig_ref)
  end
end

# 3. Target Level Configurations
puts "--- Target Level Configurations ---"
project.targets.each do |target|
  puts "Processing target: #{target.name}"
  flavors.each do |flavor, settings|
    base_configs.each do |base_name|
      new_name = "#{base_name}-#{flavor}"
      overrides = {}
      if target.name == 'Runner'
        base_bundle_id = "com.example.we_care" 
        new_bundle_id = "#{base_bundle_id}#{settings['bundle_id_suffix']}"
        overrides['PRODUCT_BUNDLE_IDENTIFIER'] = new_bundle_id
        overrides['APP_DISPLAY_NAME'] = settings['app_name']
      end
      xcconfig_key = base_name == 'Debug' ? "Debug-#{flavor}" : "Release-#{flavor}"
      xcconfig_ref = xcconfig_files[xcconfig_key]
      duplicate_config(project, target.build_configuration_list, base_name, new_name, overrides, xcconfig_ref)
    end
  end
end

# 4. Create Schemes
puts "--- Creating Schemes ---"
flavors.keys.each do |flavor|
  scheme_name = flavor
  scheme = Xcodeproj::XCScheme.new
  scheme.launch_action.build_configuration = "Debug-#{flavor}"
  scheme.archive_action.build_configuration = "Release-#{flavor}"
  scheme.profile_action.build_configuration = "Profile-#{flavor}"
  scheme.test_action.build_configuration = "Debug-#{flavor}"
  scheme.analyze_action.build_configuration = "Debug-#{flavor}"
  runner_target = project.targets.find { |t| t.name == 'Runner' }
  scheme.add_build_target(runner_target)
  scheme.save_as(project_path, scheme_name, true)
  puts "Created scheme: #{scheme_name}"
end

project.save
puts "Project saved."
