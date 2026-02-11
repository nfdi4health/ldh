class FixDoorkeeperForeignKeys < ActiveRecord::Migration[7.2]
  def up
    # grants
    remove_foreign_key :oauth_access_grants, column: :application_id rescue nil
    change_column :oauth_access_grants, :application_id, :bigint
    add_foreign_key :oauth_access_grants, :oauth_applications, column: :application_id

    # tokens
    remove_foreign_key :oauth_access_tokens, column: :application_id rescue nil
    change_column :oauth_access_tokens, :application_id, :bigint
    add_foreign_key :oauth_access_tokens, :oauth_applications, column: :application_id
  end

  def down
    remove_foreign_key :oauth_access_grants, column: :application_id rescue nil
    change_column :oauth_access_grants, :application_id, :integer
    add_foreign_key :oauth_access_grants, :oauth_applications, column: :application_id

    remove_foreign_key :oauth_access_tokens, column: :application_id rescue nil
    change_column :oauth_access_tokens, :application_id, :integer
    add_foreign_key :oauth_access_tokens, :oauth_applications, column: :application_id
  end
end
