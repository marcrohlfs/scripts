# Scripts

Helper scripts for development purposes.

## Installation

Clone the repository and add the clone directory to the ``PATH`` environment variable. The suggested clone directory is
``~/bin``.

## Usage

Information should not be maintained redundant. To prevent duplications, this _README.md_ doesn't document any usage
information. Instead, each script contains its own manual/help text. It will be printed, when the script is invoked with
the ``-h`` option.

## Limitations

The scripts should work with most Unix environments, but they have only been tested with Mac and ZSH.

Exception: _projects.sh_ and its managed project environments managed by _projects.sh_ use Mac specific functionality to
start the project Terminal. The currently implementations should be easy to extend. Pull requests appreciated ...

## Known Issues

* _projects.sh_:
  * Project names must not contain white spaces.

## Author and Maintainer

[Marc Rohlfs](https://github.com/marcrohlfs)
