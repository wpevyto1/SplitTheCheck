# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)


  fixtures :all
end

class ActionDispatch::IntegrationTest
  
end