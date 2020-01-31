# Parenbot

A bot that completes parentheses on Twitter. <https://twitter.com/parenbot>

## Usage

## Features

- [x] reply completed parens
- [x] multiple auth token rotation
- [x] auto follow back

### Setup

You must provide pre-authorized oauth credentials for the program to function.

1. Export "OAUTH_CREDENTIAL_n" environment variables with different "n" value. The value of the environment variable is in format of "<CONSUMER_KEY>,<CONSUMER_SECRET>,<ACCESS_TOKEN>,<ACCESS_TOKEN_SECRET>".
2. Run `mix run --no-halt`

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
