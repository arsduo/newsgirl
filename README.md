# MustachedOctoTyrion

_Poll: should the Github-generated-name stick?  I gotta admit, I'm kinda
growing attached to what was supposed to be a placeholder._

Generate changelogs based on Github pull requests.  Make it easy to keep
clients, app developers (both internal and external), and your future self
up-to-date with what you've done.

At 6Wunderkinder, no code goes into master except via pull request merged after
group review.  We've found this process to be very worthwhile both in ensuring
quality (it's a lot easier to raise a question in a safe group setting than one
on one) and in diffusing knowledge of our systems to the entire team. There's
many a blog post to be written about this, but one further advantage to this
system is it makes it easy to track and document our changes, since each is
accessible through the Github API.

To take advantage of that, we use MustachedOctoTyrion internally at 6W to manage
communication with our various client teams, alerting them to new features and
API changes as we merge code in.  As an open-source project, other teams with
similar workflows will, I hope, find this useful.

Features:

* _Highlight key changes_: any line starting with an upcase phrase (ADDED:,
  CHANGED:, REMOVED:, FIXED:, etc.) will be pulled out to the top of the
  chnagelog.
* _Group changes by GH issue tags_: clearly highlight certain types of changes
  (client-facing, security, documentation, etc.) by grouping them separately.
* _Exclude issues_: exclude issues with specific (or no) tags, to keep internal
  changes private.
* _Choose your own format_: output to HTML, Markdown, plain text, or add your own
  type.
* _Tag and diff_: with the tagging option on and the right Github
  permissions, MustachedOctoTyrion can tag your project and automatically generate a
  link to a diff.
* _Send email_: with the appropriate configuration options, MustachedOctoTyrion will
  send an HTML email to a destination of your choice -- perfect for cron.

**Thanks** to 6Wunderkinder, for allowing me to open-source this personal side
project, and to the API and client teams there, who've helped refine the
process both of reviewing code and of communicating changes.

## Installation

Add this line to your application's Gemfile:

    gem 'mustached_octo_tyrion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mustached_octo_tyrion

## Usage

MustachedOctoTyrion is configured via a YAML file with options.  By default, this is
located at ~/.mustached_octo_tyrion/config.yml, but you can specify another option at
run-time.

Here's a sample config file with notes:

```yml

repos:
  # default settings
  # you can also specify repo-specific options (see below), which override
  # defaults
  default:
    # you can customize the ERB templates used to generate the summaries
    templates:
      html: /path/to/template.html.erb
      markdown: /path/to/template.md.erb
      text: /path/to/template.txt.erb

    # what to generate for this repo
    output:
      email: recipient@example.com, recipient2@example.com
      md: "/path/to/file

    # tag the repo whenever you generate a new summary
    tag: true

    # generate documentation whenever there've been changes in the repo,
    # even if there are no pull requests
    generate_for_unpulled_commits: true

    # how to group the issues in the summary
    groups:
      # the name of the group (to be titlecased)
      client:
        # the Github tags
        - client
      billing:
        - accounts
        - payments

    # a catch-all for all other issues
    # if this isn't specified, issues not in groups will be ignored
    catch_all: internal

    # the Github token that has access to the repo
    # currently you need the repo permission (public_repo if it's public)
    # but hopefully someday you can have just issues permissions
    token: github_token

    # your repos
    # if you only have one, you don't to specify a defaults key
    # (technically, you don't need to specify that period, it's just useful)
    "arsduo/mustached_octo_tyrion":
      some_overridden_setting: value
      # the rest of the settings come from defaults

    "arsduo/koala": # no values = everything from defaults
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Commit tests (they should pass when `rake` is run)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
