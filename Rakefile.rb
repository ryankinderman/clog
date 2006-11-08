require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.name = 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
  # t.warning = true
end