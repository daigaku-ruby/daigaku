require 'open-uri'
require 'json'
require 'date'

module Daigaku
  module GithubClient
    # Returns the url to the master zip file of the Github repo.
    def self.master_zip_url(user_and_repo)
      "https://github.com/#{user_and_repo}/archive/master.zip"
    end

    # Returns the timestamp of updated_at for the repo from the Github API.
    def self.updated_at(user_and_repo)
      url = "https://api.github.com/repos/#{user_and_repo}"
      JSON.parse(open(url).read)['updated_at']
    end

    # Returns whether the pushed_at time from Github API is newer than the
    # stored one.
    def self.updated?(user_and_repo)
      return false unless user_and_repo

      course       = Course.new(user_and_repo.split('/').last)
      stored_time  = QuickStore.store.get(course.key(:updated_at))
      current_time = updated_at(user_and_repo)

      DateTime.parse(stored_time) < DateTime.parse(current_time)
    end
  end
end
