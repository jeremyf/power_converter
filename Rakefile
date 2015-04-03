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

task default: [:test, :rubocop]
