lib_paths = [
  '../lib',
  '../vendor/*/lib'
  ]

lib_paths.each do |lib_path|
  Dir[File.join(File.dirname(__FILE__), lib_path)].each do |lib_dir| 
    $: << lib_dir
    Dir[File.join(lib_dir, '*.rb')].each { |source_file| load source_file }
  end  
end

