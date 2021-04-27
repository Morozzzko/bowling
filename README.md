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

### `GET /api/games/:uid`

Get game info and score

**Returns** a JSON object with following structure:

* `player_name` with a player name
* `uid` with a game UID
* `state` indicates whether the game is currently `playing` or `ended`
* `score` which is a hash with 10 integer keys from 1 to 10, indicating score for each individual frame, and a `total`

Example:

```json
{
  "player_name": "Vic",
  "uid": "3cae85117835b2ae51fb325d8538ef1c",
  "state": "playing",
  "score": {
    "1": [
      0, 0
    ],
    "2": [
      0, 0
    ],
    "3": [
      0, 10
    ],
    "4": [
      0, 0
    ],
    "5": [
    ],
    "6": [
    ],
    "7": [
    ],
    "8": [
    ],
    "9": [
    ],
    "10": [
    ],
    "total": 0
  }
}
```
