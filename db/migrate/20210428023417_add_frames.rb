# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:frames) do
      primary_key :id
      foreign_key :game_id, :games, null: false
      Integer :serial_number, null: false
      String :state, null: false
      String :balls, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index %i[game_id serial_number], unique: true
    end
  end
end
