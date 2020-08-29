# frozen_string_literal: true
require "bundler/gem_tasks"
task default: :spec

namespace :gem do
  desc "Rebuild and publish the gem to the gemserver"
  task :rebuild do
    gemspec = "pass_client.gemspec"
    %x(cd ./ && gem build #{gemspec})
    gem_path = File.join("**", "*.gem")
    gem_file = Dir.glob(gem_path).max_by { |f| File.mtime(f) }
    gem_server = "http://gems.ncsasports.org"
    puts "&" * 77
    p "Uploading #{gem_file} to #{gem_server}"
    output = %x(gem inabox #{gem_file} --host #{gem_server})
    p output
  end
end
