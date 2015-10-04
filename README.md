# ![Daigaku](http://res.cloudinary.com/daigaku-ruby/image/upload/c_scale,h_100/v1426946323/rect5481_si3rjr.png)

[![Gem Version](https://badge.fury.io/rb/daigaku.svg)](http://badge.fury.io/rb/daigaku)
[![Travis Build](https://travis-ci.org/daigaku-ruby/daigaku.svg)](https://travis-ci.org/daigaku-ruby/daigaku)

Daigaku (大学) is the Japanese word for **university**.

With Daigaku you can master your way of learning the Ruby programming
language with courses that are created by the community.

Daigaku is a command line tool and a text based interface and provides
you with a number of learning tasks and explanations about the Ruby
programming language. You will learn Ruby step by step by solving small
language-explaining programming tasks.

## Installation

First of all make sure Ruby is installed on your computer.
Daigaku works with [MRI Ruby](https://www.ruby-lang.org/en/documentation/installation/) v2.x and [Rubinius](http://rubini.us/doc/en/getting-started/) v2.x.

Then open a terminal and install Daigaku by running:

    $ gem install daigaku

## Get started

To get started open a terminal and run following line:

    $ daigaku welcome

Daigaku will lead you through the setup and some important commands.

## Command line interface

Daigaku's command line interface provides several commands which you
can use in your terminal to setup the system, download new courses,
and navigate through your solutions.

Please visit the [Daigaku Wiki](https://github.com/daigaku-ruby/daigaku/wiki/How-to-use-Daigaku%27s-command-line-interface-%28CLI%29) to learn more about available commands.

![Daigaku CLI screenshot](http://res.cloudinary.com/daigaku-ruby/image/upload/v1427558807/daigaku-cli-screenshot_xgpav6.png)

## Daigaku screen

Daigaku's text based interface - the Daigaku screen - shows your installed courses and allows you to navigate through their chapters and units. In the task view you can read the unit's task and validate your solution code.

Please visit the [Diagaku Wiki](https://github.com/daigaku-ruby/daigaku/wiki/How-to-learn-Ruby-in-the-Daigaku-screen) to learn how to use the Daigaku screen.

![Daigaku screen screenshot](http://res.cloudinary.com/daigaku-ruby/image/upload/v1430859202/daigaku-taskview_erwzrh.png)

## Contributing

We encourage you to contribute to Daigaku development and course creation.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant code of conduct](http://contributor-covenant.org/version/1/2/0).

### Creating Daigaku courses

Daigaku is a great tool, but it's nothing without courses to learn from.
Go ahead and help with making Daigaku a worthwile and fun resource for learning Ruby!

Daigaku uses the course "Get started with Ruby" by default.
Any contributions to the basic Daigaku course are more than welcome.
To add chapters to the course fork it from https://github.com/daigaku-ruby/Get_started_with_Ruby
and follow its guidelines for adding chapters or units.

You can also create your own Daigaku courses and make them available to the community.
Learn how to create a Daigaku course in the [Daigaku Wiki](https://github.com/daigaku-ruby/daigaku/wiki/How-to-create-a-Daigaku-course).

### Development

Any ideas, feature proposals, filing and feedback on issues are very welcome.
We use the [git branching model](http://nvie.com/posts/a-successful-git-branching-model/) described by [nvie](https://github.com/nvie).

Here's how to contribute:

1. Fork it ( https://github.com/daigaku-ruby/daigaku/fork )
2. Create your feature branch (`git checkout -b feature/my-new-feature develop`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

Please try to add RSpec tests with your new features. This will ensure that your code does not break existing functionality and that your feature is working as expected.

Ah, don't forget step 6: Celebrate that you made Daigaku a better tool after your code was merged in! :octocat: :tada:

### License

Daigaku is released under the [MIT License](http://opensource.org/licenses/MIT).
