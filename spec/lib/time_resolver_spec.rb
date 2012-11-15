require 'spec_helper'

module Newsgirl
  describe TimeResolver do

    let(:today) { Date.today.to_time }

    around :each do |block|
      Timecop.freeze(today) do
        block.call
      end
    end

    describe "string shortcuts" do
      it "turns t into today's date" do
        expect(TimeResolver.resolve("t")).to eq([Date.today.to_time])
      end

      it "turns today into today's date" do
        expect(TimeResolver.resolve("today")).to eq([Date.today.to_time])
      end

      it "turns y into yesterday's date" do
        expect(TimeResolver.resolve("y")).to eq([(Date.today - 1).to_time])
      end

      it "turns yesterday into yesterday's date" do
        expect(TimeResolver.resolve("yesterday")).to eq([(Date.today - 1).to_time])
      end
    end

    describe "ranges of dates" do
      it "turns them into an array of times" do
        expect(TimeResolver.resolve((Date.today - 4)..Date.today)).to eq(
          5.times.map {|i| (Date.today - i).to_time}.sort
        )
      end
    end

    describe "arrays of dates and times" do
      it "turns them into a sorted array" do
        array = [Date.today, Time.now - 5000, Date.today - 6, Time.now]
        expect(TimeResolver.resolve(array)).to eq(
          array.map(&:to_time).sort
        )
      end
    end

    describe "a string" do
      it "parses it with time" do
        expect(TimeResolver.resolve("2012/12/04 15:39")).to eq(
          [Time.parse("2012/12/04 15:39")]
        )
      end
    end

    describe "an int" do
      it "parses it with time" do
        expect(TimeResolver.resolve(12342)).to eq([Time.at(12342)])
      end
    end

    describe "a float" do
      it "parses it with time" do
        expect(TimeResolver.resolve(12342.5)).to eq([Time.at(12342.5)])
      end
    end

    describe "other objects" do
      it "turns the object into a single array of [obj.to_time]" do
        obj = stub("time-like object", to_time: 123345)
        expect(TimeResolver.resolve(obj)).to eq([obj.to_time])
      end

      it "turns dates into a single array of the equivalent time" do
        expect(TimeResolver.resolve(Date.today)).to eq([Date.today.to_time])
      end

      it "array-izes Time objects" do
        expect(TimeResolver.resolve(Time.at(100))).to eq([Time.at(100)])
      end
    end
  end
end
