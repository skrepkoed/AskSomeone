# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|

  # DatabaseCleaner settings
  
  config.use_transactional_fixtures = false
  config.before(:each, sphinx: true) do
    
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
    ThinkingSphinx::Test.index
  end
end