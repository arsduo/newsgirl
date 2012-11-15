require 'gh'

module Newsgirl
  # Public: A wrapper for a Github repo.
  class GitRepo
    # Public: direct access to the authenticated GH instance.  Useful if you
    # want to make additional queries.
    attr_reader :api

    # Public: the name of the Github repo ("arsduo/newsgirl").
    attr_reader :project

    # Public: Instantiate a representation of a new Github project.  From here,
    # you can access issues, pull requests, etc.
    #
    # project - the name of the Github repo, with owner ("arsduo/newsgirl")
    # gh_options - a hash of options for the GH gem, most often including
    # authentication via token or basic auth.
    def initialize(project, gh_options = {})
      @project = project
      @api = GH::DefaultStack.build(gh_options)
    end

    # Public: Get all pull requests for a given state.  Github unfortunately
    # does not currently allow more specificity than simply "all open" and "all
    # closed".
    #
    # state - :open or :closed, mapping to the Github states
    #
    # Returns an array of hashes representing the repos' pull requests.
    def pulls(state)
      @api["repos/#{@project}/pulls?state=#{state}"]
    end

    # Public: gets a specific pull request.
    #
    # Returns a hash representing the desired pull request.
    def pull_request(number)
      @api["repos/#{@project}/pulls/#{number}"]
    end

    # Internal: Get all issues for a given state since a given timestamp.    #
    #
    # state - :open or :closed, mapping to the Github states
    # since - get only issues after this ISO8601 timestamp.
    #
    # Returns an array of hashes representing the repos' issues.
    def issues(state, from = nil)
      since = from ? "&since=#{from.iso8601}" : ""
      @api["repos/#{@project}/issues?state=#{state}#{since}"]
    end

    # Public: gets a specific issue request.
    #
    # Returns a hash representing the desired issue request.
    def issue(number)
      @api["repos/#{@project}/issues/#{number}"]
    end

    # Public: get only issues that were closed on a specific date.
    #
    # date_filter - a Date object or an array of Dates.
    #
    # Returns an array of issue hashes that fall in the given range.
    def closed_issues(date_filter)
      dates = Array[date_filter].sort
      # Get all the dates since the earliest date provided, then
      # filter out any issues not included in the provided filter.
      issues("closed", dates.first.to_time).select do |issue|
        dates.include?(Time.parse(issue["closed_at"]).to_date)
      end
    end

    # Public: get merged issue and pull request data for dates in a given date
    # range.  This is useful because Github pull requests and their issues --
    # though linked -- are not equal, and contain different information.
    # The PRs know about the code, the merged state, etc., while the issues
    # know about their labels and can be queried with a since parameter.
    #
    # date_filter - a Date object or an array of Dates.
    #
    # Returns an array of issue/PR hashes, containing the merged information.
    # (PR info is merged second, so it overwrites equivalent keys in the
    # issue.)
    def merged_pull_requests(date_filter)
      closed_issues(date_filter).inject([]) do |merged_issues, issue|
        # Github issues and PRs share the same number
        pull_req = pull_request(issue["number"])
        # see if this is a real, merged pull request$
        if pull_req["merged_at"] # this was merged, not closed
          merged_issues << issue.to_hash.merge(pull_req.to_hash)
        end
        merged_issues
      end
    end
  end
end
