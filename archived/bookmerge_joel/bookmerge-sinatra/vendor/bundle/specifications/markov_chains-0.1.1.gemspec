# -*- encoding: utf-8 -*-
# stub: markov_chains 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "markov_chains"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["justindomingue"]
  s.date = "2015-01-01"
  s.email = ["justin.domingue@hotmail.com"]
  s.homepage = "https://github.com/justindomingue/markov_chains"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "A simple random text generator using markov chains."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
