# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:games) do
      primary_key :id
      column :uid, String, null: false
      String :player_name, null: false
      String :state, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :uid, unique: true
    end
  end
end
