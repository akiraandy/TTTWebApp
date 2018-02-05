require 'spec_helper'

describe 'App' do
  it "should allow accessing the welcome page" do
    get "/"
    expect(last_response).to be_ok
  end
end
