# Run `rake unpatched.gemspec` to update the gemspec.
Gem::Specification.new do |s|
  # general infos
  s.name        = "unpatched"
  s.version     = "0.0.1"
  s.description = "Convenience library without a single monkey-patch."
  s.homepage    = "http://github.com/rkh/unpatched"
  s.summary     = s.description

  # generated from git shortlog -sn
  s.authors = [
    "Konstantin Haase"
  ]

  # generated from git shortlog -sne
  s.email = [
    "konstantin.mailinglists@googlemail.com"
  ]

  # generated from git ls-files
  s.files = [
    "License",
    "README.md",
    "Rakefile",
    "lib/unpatched.rb",
    "lib/unpatched/version.rb",
    "spec/unpatched_spec.rb",
    "unpatched.gemspec"
  ]

  # dependencies
  s.add_development_dependency "rspec", "~> 2.0"
end
