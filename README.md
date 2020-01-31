# Parenbot

A bot that completes parentheses on Twitter.

## Usage

### Authentication

You must export at least two environment variables `CONSUMER_KEY` and
`CONSUMER_SECRET` for the program to work. On the first run, export these two
environment variables and run `mix run --no-halt`. Follow the prompt to
authenticate your twitter account and follow the instruction to get another two
environment variables `ACCESS_TOKEN` and `ACCESS_TOKEN_SECRET`.

Export these two variable and build the program. Now you're ready to go.

## Roadmap

- [x] reply completed parens
- [ ] auto follow back
- [x] multiple auth token rotation

## Copyright

Copyright 2020 Shou Ya

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
