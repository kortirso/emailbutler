class CreateEmailbutlerTables < ActiveRecord::Migration[7.0]
  def self.up
    enable_extension 'pgcrypto' unless extensions.include?('pgcrypto')
    enable_extension 'uuid-ossp' unless extensions.include?('uuid-ossp')

    create_table :emailbutler_messages do |t|
      t.string :status, null: false, default: ''
      t.uuid :uuid, null: false, default: ''
      t.string :mailer, null: false
      t.string :action, null: false
      t.jsonb :params, null: false, default: {}
      t.string :send_to, array: true
      t.timestamps
    end
    add_index :emailbutler_messages, :uuid, unique: true
  end

  def self.down
    drop_table :emailbutler_messages
  end
end
