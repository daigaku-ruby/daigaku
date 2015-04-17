require 'spec_helper'

describe Daigaku::GithubClient do

  describe "#master_zip_url" do
    it "returns the url to the master zip file for the given github repo" do
      url = "https://github.com/a/b/archive/master.zip"
      expect(Daigaku::GithubClient.master_zip_url('a/b')).to eq url
    end
  end

  describe "#pushed_at" do
    it "fetches the pushed_at timestamp from the Github API" do
      expected_timestamp = "2015-10-21T12:00:00Z"
      response = { pushed_at: expected_timestamp }.to_json
      url = "https://api.github.com/repos/a/b"

      stub_request(:get, url)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: response, headers: {})

      timestamp = Daigaku::GithubClient.pushed_at('a/b')

      expect(timestamp).to eq expected_timestamp
    end
  end

  describe "#updated?" do
    before do
      @received_timestamp = "2015-10-21T12:00:00Z"
      response = { pushed_at: @received_timestamp }.to_json
      url = "https://api.github.com/repos/a/b"

      stub_request(:get, url)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: response, headers: {})
    end

    it "returns true if content was pushed to the Github repo" do
      QuickStore.store.set('courses/b/pushed_at', "2015-10-21T11:59:59Z")
      expect(Daigaku::GithubClient.updated?('a/b')).to be_truthy
    end

    it "returns false if no content was pushed to the Github repo" do
      QuickStore.store.set('courses/b/pushed_at', @received_timestamp)
      expect(Daigaku::GithubClient.updated?('a/b')).to be_falsey
    end
  end
end
