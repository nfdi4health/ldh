class FixDoorkeeperForeignKeys < ActiveRecord::Migration[7.2]
  def up
    # grants
    change_column :oauth_access_grants, :application_id, :bigint
    change_column :oauth_access_grants, :resource_owner_id, :bigint


    # tokens
    change_column :oauth_access_tokens, :application_id, :bigint
    change_column :oauth_access_tokens, :resource_owner_id, :bigint

  end

  def down

    change_column :oauth_access_grants, :application_id, :integer
    change_column :oauth_access_tokens, :application_id, :integer
    change_column :oauth_access_grants, :resource_owner_id, :integer
    change_column :oauth_access_tokens, :resource_owner_id, :integer

  end
end
