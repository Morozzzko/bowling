# Bowling

## Install

0. Make sure you have a correct Ruby version installed. See [.ruby-version](.ruby-version) for an up-to-date info.
1. Download this repo: `git clone git@github.com:Morozzzko/bowling.git`
2. Navigate to the downloaded directory: `cd bowling`
3. Run `bundle install` to install dependencies
4. Run `bundle exec rackup` to run the server or `bundle exec rspec` to run the tests

## API

### `POST /api/games`

Create a new bowling game.

**Required parameter**: `player_name` – name of the current player. Feel free to use aliases, nicknames or pet names.

**Returns** 422 on invalid input and 200 with `{ "game_uid": String }` on success
