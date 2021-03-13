require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::MattermostUrlsToFiles do
  before(:each) do
    @valid_options = Agents::MattermostUrlsToFiles.new.default_options
    @checker = Agents::MattermostUrlsToFiles.new(:name => "MattermostUrlsToFiles", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
