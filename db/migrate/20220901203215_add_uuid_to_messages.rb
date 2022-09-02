class AddUuidToMessages < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')
    enable_extension 'uuid-ossp' unless extensions.include?('uuid-ossp')

    add_column :emailbutler_messages, :uuid, :uuid, null: false, index: true
  end
end
