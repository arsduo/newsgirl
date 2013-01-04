require 'spec_helper'

module Newsgirl
  describe "Git integration", :integration do
    let(:repo) { GitRepo.new("arsduo/newsgirl") }

    describe "#issue" do
      it "gets an issue" do
        expect(repo.issue(1)).to include({
          "title"=>"Add config module",
          "created_at"=>"2012-11-10T11:36:34Z",
          "login"=>"arsduo",
          "id"=>48325
        })
      end
    end

    describe "#issues" do
      it "returns all open issues if requested" do
        # there is of course no permanently open issue, but we can verify that
        # we get something back
        issues = repo.issues("open")
        expect(issues).to be_an(Array)
        # we know issue 4 is closed
        expect(issues.map {|i| i["number"]}).not_to include(4)
      end

      it "returns closed issues if requested" do
        # there is of course no permanently open issue, but we can verify that
        # we get something back
        issues = repo.issues("open")
        expect(issues).to be_an(Array)
        # we know issue 4 is closed
        expect(issues.map {|i| i["number"]}).not_to include(4)
      end
    end
  end
end

