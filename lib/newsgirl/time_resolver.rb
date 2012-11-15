module Newsgirl
  # Public: Takes an input of some representation of times -- a string, a date
  # or time object, or an array or range of such objects.  It turns them into
  # a standardized version (a sorted array) ready for use by a GitRepo.
  module TimeResolver

    # Public: Format a range of time or group of dates in such a way that we
    # can use it to filter Git issues.
    #
    # times - a string ("t" or "today", "y" or "yesterday", a String
    # representation of a date), an int or float Unix timestamp, a Date or Time
    # object, an Array of Dates and/or Times, or a range of Dates.
    #
    # Returns a sorted array representing the Times described by the input.
    def self.resolve(moments)
      objects = case moments
      when "t", "today"
        Date.today.to_time
      when "y", "yesterday"
        (Date.today - 1).to_time
      when String
        Time.parse(moments)
      when Integer, Float
        Time.at(moments)
      when Range
        # Turn the Range into an Array
        # Note: this works with Dates, but not with Times, whose ranges can't
        # be enumerated.
        moments.each.map(&:to_time)
      when Array
        # Sort the array so the first element is the earliest, and turn them
        # all into moments.
        moments.map(&:to_time).sort
      else
        moments.to_time
      end
      # Ensure we have a flat Array
      [objects].flatten
    end
  end
end

