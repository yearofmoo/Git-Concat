# Git-Concat

Git-Concat is a simple ruby script that allows you specify a series of files that will be combined into single (or multiple) files.

This tool is very useful for simple javascript tools that require a master file to be always generated and up to date.

## Requirements

- Git + Ruby

## Usage

By specifying a **.gitconcat** (or .gitconcat.yml) file, the files within can be outlined below.

Here is an example for combining javascript files:

```yaml
master_javascript:
  input:
    - javascripts/*.js
    - extra_javascript_file.js
  output:
    - combined.js
    - another_combined_file_with_the_same_data.js
```

Multiple concatenations can also be defined:

```yaml
stylesheet1:
  input:
    - stylesheets/1.css
    - stylesheets/2.css
    - stylesheets/3.css
  output:
    - 123.css

stylesheet2:
  input:
    - stylesheets/4.css
    - stylesheets/5.css
    - stylesheets/6.css
  output:
    - 456.css
```

Timestamp values can also be specified:

```yaml
config:
  stamp: 'random'
  other_variable: '1234567890'

javascripts:
  input:
    - js/**.js
  output:
    - master_%{stamp}.js
    - other_%{other_variable}.js
```

Each time you issue a commit then the concatenation process will be executed.

You may also call this manually:

```bash
$ ./.git/hooks/pre-commit
```

## Installation

Git-Concat needs to be installed for each repository that will use its features, but this is very easy.

### Install with:

```bash
$ curl https://raw.github.com/matsko/Git-Concat/master/install.sh | bash
```
