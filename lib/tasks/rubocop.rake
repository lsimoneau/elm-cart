begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
  warn 'rubocop not available, rake task not provided.'
end
