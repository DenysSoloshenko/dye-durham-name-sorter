# Name Sorter

A Ruby command-line program for the Dye & Durham coding assessment. It sorts names by last name and then
by given names, prints the result, and writes it to `sorted-names-list.txt`.

## Requirements

- Ruby 3.1 or newer
- Bundler

## Setup and usage

```sh
bundle install
./bin/name-sorter ./unsorted-names-list.txt
```

The input file must contain one name per line. A name has one to three given names followed by a last
name. Blank lines are ignored and extra whitespace is normalized.

The sorted names are printed to the terminal and written to `sorted-names-list.txt` in the current
directory. An existing output file is overwritten only after the complete input has been validated.

## Sorting

Names are compared by last name and then by each given name in order. Comparison is case-insensitive,
while the original spelling is preserved.

The assessment example contains an inconsistency: the input includes `Vaugh Lewis`, while the expected
output shows `Vaughn Lewis`. This implementation preserves `Vaugh Lewis` because the requirement is to
sort names, not change their spelling. The example test documents this decision.

## Tests

```sh
bundle exec rake
```

The default Rake task runs the RSpec test suite and RuboCop. Tests cover the sorting rules, input
validation, command output, file overwriting, errors, and UTF-8 input.

## Continuous integration

`.github/workflows/ci.yml` runs `bundle exec rake` on every push and pull request using GitHub Actions.

## Structure

- `Name` parses a name and provides its sorting key.
- `Parser` processes input lines and reports line numbers for invalid names.
- `Sorter` applies the ordering rule.
- `CLI` handles the input file, output file, terminal output, and errors.

## Author

Denys Soloshenko
