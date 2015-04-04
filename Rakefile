require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new do |t|
    # Why .hound.yml? So I can integrate with HoundCI if I choose
    t.options << '--config=./.hound.yml'
  end
rescue LoadError
  puts 'Unable to load RuboCop. Who will enforce your Ruby styleguide now?'
end

task :validate_coverage_goals do
  require 'json'
  goal_percentage = 100
  json_document = File.new(File.expand_path('../coverage/.last_run.json', __FILE__)).read
  coverage_percentage = JSON.parse(json_document).fetch('result').fetch('covered_percent').to_i
  if goal_percentage > coverage_percentage
    abort("Code Coverage Goal Not Met:\n\t#{goal_percentage}%\tExpected\n\t#{coverage_percentage}%\tActual")
  end
end

task default: [:test, :validate_coverage_goals, :rubocop]
