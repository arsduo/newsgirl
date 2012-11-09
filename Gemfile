source "https://rubygems.org"

# Specify your gem's dependencies in mustached_octo_tyrion.gemspec
gemspec

gem "rake"

group :development, :test do
  # pry rocks
  gem "pry"

  # Testing infrastructure
  gem "guard"
  gem "guard-rspec"
  gem "faker"
  gem "timecop"

  if RUBY_PLATFORM =~ /darwin/
    # OS X integration
    gem "ruby_gntp"
    gem "rb-fsevent"
  end
end
