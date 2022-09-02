class AddDataFieldsToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :emailbutler_messages, :mailer, :string, null: false
    add_column :emailbutler_messages, :action, :string, null: false
    add_column :emailbutler_messages, :params, :jsonb, null: false, default: {}
    add_column :emailbutler_messages, :send_to, :string, array: true
  end
end
