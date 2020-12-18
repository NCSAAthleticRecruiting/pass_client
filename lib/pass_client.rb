# frozen_string_literal: true

Dir[File.dirname(__FILE__) + "/pass_client/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/pass_client/athletes/*.rb"].each { |file| require file }
require "json"

module PassClient
end
