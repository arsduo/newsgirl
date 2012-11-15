require 'spec_helper'

module Newsgirl
  describe GitRepo do
    let(:project) { "arsduo/newsgirl" }
    let(:options) { { gh_options: stub("option") } }
    let(:repo) { GitRepo.new(project, options) }

    describe "#initialize" do
      it "stores the repo" do
        expect(repo.project).to eq(project)
      end

      it "creates an API instance with the provided options" do
        expect(repo.api.options).to eq(options)
      end

      it "defaults options to {}" do
        expect(GitRepo.new(project).api.options).to eq({})
      end
    end

    describe "#pulls" do
      it "gets the pulls for the project in the state requested" do
        # note: spec/integration tests will test the actual query
        state = Time.now.to_s
        repo.api.should_receive(:[]).
              with("repos/#{project}/pulls?state=#{state}").
              and_return(result = stub)
        expect(repo.pulls(state)).to eq(result)
      end
    end

    describe "#pull_request" do
      it "gets the desired pull request" do
        # note: spec/integration tests will test the actual query
        number = rand * 100
        repo.api.should_receive(:[]).
              with("repos/#{project}/pulls/#{number}").
              and_return(result = stub)
        expect(repo.pull_request(number)).to eq(result)
      end
    end

    describe "#issues" do
      it "gets the issues for the project in the state and timeframe requested" do
        # note: spec/integration tests will test the actual query
        state = "wavering"
        since = Time.now
        repo.api.should_receive(:[]).
              with("repos/#{project}/issues?state=#{state}&since=#{since.iso8601}").
              and_return(result = stub)
        expect(repo.issues(state, since)).to eq(result)
      end

      it "gets all issues if no time specified" do
        state = "wavering"
        repo.api.should_receive(:[]).
              with("repos/#{project}/issues?state=#{state}").
              and_return(result = stub)
        expect(repo.issues(state)).to eq(result)
      end
    end

    describe "#issue" do
      it "gets the desired issue request" do
        # note: spec/integration tests will test the actual query
        number = rand * 100
        repo.api.should_receive(:[]).
              with("repos/#{project}/issues/#{number}").
              and_return(result = stub)
        expect(repo.issue(number)).to eq(result)
      end
    end

    describe "#merged_issues" do
      let(:time) { Time.now }
      let(:issues) {
        [
          {
            "title" => "Foo",
            "number" => 1,
            "other_data" => "123"
          },
          {
            "title" => "Bar",
            "number" => 2,
            "other_data" => "abc",
            "moar data" => "c"
          },
          {
            "title" => "Baz",
            "number" => 4,
            "other_data" => "def"
          },
          {
            "title" => "A Real Issue",
            "number" => 7,
            "other_data" => "def"
          }
        ]
      }

      let(:pulls) {
        [
          {
            "title" => "Foo",
            "number" => 1,
            "other_data" => "1234",
            "merged_at" => (time - 362023).to_s
          },
          {
            "title" => "Foo",
            "number" => 2,
            "other_data" => "ABCDEF",
            "merged_at" => time
          },
          {
            "title" => "Foo",
            "number" => 4,
            "other_data" => "def"
          }
        ]
      }

      def pull_for_issue(number)
        pulls.find {|pr| pr["number"] == number} || {}
      end

      before :each do
        repo.stub(:closed_issues).with(anything).and_return(issues)
        repo.stub(:pull_request) {|number| pull_for_issue(number) }
      end

      let(:merged_prs) { repo.merged_pull_requests(stub) }

      pending "Missing spec for closed issues!"

      it "filters down to only merged pull requests" do
        expect(merged_prs.map {|pr| pr["number"]}).to eq([1, 2])
      end

      it "merges the pull request data into the issue" do
        expect(merged_prs).to eq([
          {
            "title" => "Foo",
            "number" => 1,
            "other_data" => "1234",
            "merged_at" => (time - 362023).to_s
          },
          {
            "title" => "Foo",
            "number" => 2,
            "other_data" => "ABCDEF",
            "moar data" => "c",
            "merged_at" => time
          }
        ])
      end
    end
  end
end
