require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

task :default => [:spec]

desc "Run all module spec tests (Requires rspec-puppet gem)"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color']
  t.pattern = 'spec/{classes,defines,unit}/**/*_spec.rb'
end

desc "Create the fixtures directory"
task :spec_prep do
  begin
    fixtures = YAML.load_file("spec/fixtures.yml")["fixtures"]
  rescue Errno::ENOENT
    return
  end

  if not fixtures
    return
  end

  if fixtures.include? "repositories"
    fixtures["repositories"].each do |pair|
      pair.each do |fixture, repo|
        target = "spec/fixtures/"+fixture
        system("test -d #{target} || git clone #{repo} #{target}")
      end
    end
  end

  if fixtures.include? "symlinks"
    fixtures["symlinks"].each do |pair|
      pair.each do |fixture, source|
        target = "spec/fixtures/"+fixture
        system("test -e #{target} || ln -s #{source} #{target}")
      end
    end
  end
end

desc "Clean up the fixtures directory"
task :spec_clean do
  begin
    fixtures = YAML.load_file("spec/fixtures.yml")["fixtures"]
  rescue Errno::ENOENT
    return
  end

  if not fixtures
    return
  end

  if fixtures.include? "repositories"
    fixtures["repositories"].each do |pair|
      pair.each do |fixture, repo|
        target = "spec/fixtures/"+fixture
        system("rm -rf #{target}")
      end
    end
  end

  if fixtures.include? "symlinks"
    fixtures["symlinks"].each do |pair|
      pair.each do |fixture, source|
        target = "spec/fixtures/"+fixture
        system("rm #{target}")
      end
    end
  end
end

task :spec_full do
  Rake::Task[:spec_prep].invoke
  Rake::Task[:spec].invoke
  Rake::Task[:spec_clean].invoke
end

desc "Build puppet module package"
task :build do
  # This will be deprecated once puppet-module is a face.
  begin
    Gem::Specification.find_by_name('puppet-module')
  rescue Gem::LoadError, NoMethodError
    require 'puppet/face'
    pmod = Puppet::Face['module', :current]
    pmod.build('./')
  end
end

desc "Check puppet manifests with puppet-lint"
task :lint do
  # This requires pull request: https://github.com/rodjek/puppet-lint/pull/81
  system("puppet-lint manifests")
  system("puppet-lint tests")
end
