class AddUuidToMessages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'uuid-ossp'
    add_column :emailbutler_messages, :uuid, :uuid, null: false, index: true
  end
end
