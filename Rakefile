require 'rake'
require 'rake/testtask'

task :default => ['test:unit', 'test:integration']

namespace :test do
  test_suites = [:unit, :integration]
  namespace :suite do
    test_suites.each do |test_suite|
      Rake::TestTask.new do |t|
        t.name = test_suite.to_s
        t.test_files = FileList["test/#{test_suite}/**/*_test.rb"]
        t.verbose = true
        # t.warning = true
      end
    end
  end

  test_suites.each do |test_suite|
    desc "Run #{test_suite} test suite"
    task test_suite do
      puts "\nRunning suite: #{test_suite}"
      Rake.application["test:suite:#{test_suite}".to_sym].invoke
    end
  end

  task :all => test_suites
end
