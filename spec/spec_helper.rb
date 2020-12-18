# frozen_string_literal: true

require "pass_client"

RSpec.configure do |c|
  c.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  c.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  c.shared_context_metadata_behavior = :apply_to_host_groups

  c.before(:suite) do
    PassClient.configure do |config|
      config.auth_id = "NOT_CHANGE_ME"
      config.secret_key = "NOT_CHANGE_ME"
    end
  end
end
