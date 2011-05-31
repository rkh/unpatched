$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue LoadError => e
  $stderr.puts e
end

desc "run specs"
task(:spec) { ruby '-S rspec spec' }

desc "generate gemspec"
task 'unpatched.gemspec' do
  require 'unpatched/version'
  content = File.read 'unpatched.gemspec'

  fields = {
    :authors => `git shortlog -sn`.scan(/[^\d\s].*/),
    :email   => `git shortlog -sne`.scan(/[^<]+@[^>]+/),
    :files   => `git ls-files`.split("\n").reject { |f| f =~ /^(\.|Gemfile)/ }
  }

  fields.each do |field, values|
    updated = "  s.#{field} = ["
    updated << values.map { |v| "\n    %p" % v }.join(',')
    updated << "\n  ]"
    content.sub!(/  s\.#{field} = \[\n(    .*\n)*  \]/, updated)
  end

  content.sub! /(s\.version.*=\s+).*/, "\\1\"#{Unpatched::VERSION}\""
  File.open('unpatched.gemspec', 'w') { |f| f << content }
end

task :gemspec => 'unpatched.gemspec'
task :default => :spec
task :test    => :spec
