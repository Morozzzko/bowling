# Bowling

## Install

1. Make sure you have a correct Ruby version installed. See [.ruby-version](.ruby-version) for an up-to-date info.
2. Download this repo: `git clone git@github.com:Morozzzko/bowling.git`
3. Navigate to the downloaded directory: `cd bowling`
4. Run `bundle install` to install dependencies
5. Run `bundle exec rake db:migrate` to run migrations
6. Run `bundle exec rackup` to run the server 

## Running tests

1. Perform steps 1-4 of "Install" section
2. Run  `RACK_ENV=test bundle exec rake db:migrate` to create test database
3. Run `bundle exec rspec` to run the tests

## API

### `POST /api/games`

Create a new bowling game.

**Required parameter**: `player_name` – name of the current player. Feel free to use aliases, nicknames or pet names.

**Returns** 422 on invalid input or 200 with [Game composite](#user-content-game-composite) on success

### `GET /api/games/:uid`

Get game info and score

**Returns** a JSON object with [Game composite](#user-content-game-composite)


### `POST /api/games/:uid/knocked_down_pins`

Notify that a player has knocked down specific number of pins.

**Required parameter**: `pins` – number of pins knocked down after a throw.

**Returns** 422 on invalid input or 200 with [Game composite](#user-content-game-composite) on success

### Game composite

It's an object which is returned from all of three API endpoints. 


* `player_name` with a player name
* `uid` with a game UID
* `state` indicates whether the game is currently `playing` or `ended`
* `score` which is a hash with integer keys from 1 to 10, indicating score for each individual frame, and a `total`. Score for each individual frame is an object, too. It has two keys: `balls`, which lists how many pins were knocked down by each ball, and `score`.

Example:
