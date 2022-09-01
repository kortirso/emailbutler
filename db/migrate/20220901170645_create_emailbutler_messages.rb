class CreateEmailbutlerMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :emailbutler_messages do |t|
      t.string :status, null: false, default: ''
      t.timestamps
    end
  end
end
