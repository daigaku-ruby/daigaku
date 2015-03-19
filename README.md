# Daigaku

Daigaku is the Japanese word for *university*.
With Daigaku you can master your way of learning the Ruby programming language on the command line.

Daigaku is a command line tool and a text based interface and provides you with a number of learning tasks and explanations about the Ruby programming
langage. You will learn Ruby step by step by solving small language-explaining programming tasks.

## Installation

First of all make sure Ruby is installed on your computer.

Then open a terminal and install Daigaku by running:

    $ gem install daigaku

## Get started

To get started open a terminal and run following line:

    $ daigaku welcome

Daigaku will lead you through the setup and some important commands.

---

To start learning Ruby and solve some taks run:

    $ daigaku learn

This opens the Daigaku text based interface in your terminal.

---

Before writing code to solve the tasks run following command:

    $ daigaku scaffold

This will create a *solutions* directory with the approiate course folders and empty solution files for each learning task.

## Command line interface

For an overview of all available daigaku commands run:

    $ daigaku

### About
Read some general information about Daigaku:

```
$ daigaku about
```

### Welcome
Get a short introduction, setup the daigaku paths for courses and your solutions, and learn some important daigaku commands:

```
$ daigku welcome
```

### Courses
**List** available courses:

```
$ daigaku courses list
```

---

**Download** course from a url:

```
$ daigaku courses download http://exmaple.com/course.zip
```

**Download** course from a Github repository:

```
$ daigaku courses download --github=user/repo-name
# or the short version
$ daigaku courses download -g user/repo-name
```

---

Daigaku will download an initial "Get-started-with-Ruby" course if you just run:

```
$ daigaku download courses
```

### Setup
**Init** the base path where you want to save courses and solutions and create the `courses` and `solutions` folders.

```
$ daigaku setup init
```

---

**List** the paths to your courses and solutions:

```
$ daigaku setup list
```

---

**Set** the daigaku paths:

*Solutions directory:*

```
$ daigaku setup set --solutions_path=/path/to/solutions
$ daigaku setup set -s /path/to/solutions # short version
```

*Courses directory:*

```
$ daigaku setup set --courses_path=/path/to/courses
$ daigaku setup set -c /path/to/courses # short version
```

*Both solution and courses diretory:*

```
$ daigaku setup set --paths=/base_path/for/courses/and/solutions
$ daigaku setup set -p /base_path/for/courses/and/solutions # short version
```

### Scaffold
**Scaffold** empty solution files in the configured `solutions` folder:

```
$ daigaku scaffold
```

### Solutions
**Open** your solutions folder in a new system window:

```
$ daigaku solutions open
```

---

**Open** a certain course's solution folder in a new system window:

```
$ daigaku solutions open Course_name
```

### Learn
**Open** the Daigaku's **text based inteface** to navigate through courses, chapters and units.

```
$daigaku learn
```

## Navigation and Short Keys in the Text Based Interface

* Navigation through the menu: `UP` and `DOWN` keys
* Enter a menu point: `ENTER` key
* Go back: `BACKSPACE` key
* Close Daigaku: `ESC` key

If you are in the unit's view with the task description you can use followin keys:

* Scroll through task description: `UP` and `DOWN` keys, `PAGE UP` and `PAGE_DOWN` keys, `LEFT` and `RIGHT` keys
* **v**alidate your solution code: `v` key
* **c**lear screen to hide validation results: `c` key

## Contributing

1. Fork it ( https://github.com/daigaku-ruby/daigaku/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
