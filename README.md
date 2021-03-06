# Git-Concat

Git-Concat is a simple ruby script that allows you specify a series of files that will be combined into single (or multiple) files.

This tool is very useful for simple javascript tools that require a master file to be always generated and up to date.

A full explanation of the plugin can be found at http://www.yearofmoo.com/code/Git-Concat.html
.

## Requirements

- Git
- Ruby (with **Rubygems**, **YAML**, and **MD5 Digest**)

## Usage

By specifying a **.gitconcat** (or **.gitconcat.yml**) file, the files within can be outlined below.
This file must be created within the root folder of the project where the .git folder exists.

### Basic Usage

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

### Multiple Concatenations

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

### Exluding files

Certain files can also be excluded from the the input fields search list.

```yaml
stylesheet1:
  exclude:
    - master.css
  input:
    - stylesheets/1.css
    - stylesheets/2.css
    - stylesheets/3.css
  output:
    - master.css
```

### Custom Variables

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

the **stamp** value will be set automatically as the current timestamp (when the script is executed) if not defined in the config block.

### Digest Values

A digest value can be added directly to any of the output file names. The digest itself will be the md5 hash of the final concatenated file.

```yaml
javascripts:
  input:
    - js/**.js
  output:
    - final_%{digest}.js
```

### How to run the process

Each time you issue a commit then the concatenation process will be executed.

**You may also call this manually**

```bash
$ ./.git/hooks/pre-commit
```

## Filters

Filters can also be added to the file which will be run after the concatenation and just before the final file is created.

The following example will minify the final concatenated javascript file.

```yaml
javascripts:
  filters:
    - jsmin %{input} > %{output}
  input:
    - js/**.js
  output:
    - final_%{digest}.js

```

Filters can only be defined in the concatenation area and not in the config definition block.

## Installation

Git-Concat needs to be installed for each repository that will use its features, but this is very easy.

### Before Install

- Make sure you have git and ruby installed.
- You will need to ensure that the install script is run within a git repository.
- You will need to **remove the .git/hooks/pre-commit** file (its there by default) or move it if its already being used.

### Install with

```bash
curl https://raw.github.com/yearofmoo/Git-Concat/master/install.sh | bash
```

### Upgrading

Just remove the **./.git/hooks/pre-commit** file and run the install script again.

## More Info

Please visit http://www.yearofmoo.com/code/Git-Concat.html to read more about this amazing plugin.
