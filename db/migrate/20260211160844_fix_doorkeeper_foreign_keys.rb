class FixDoorkeeperForeignKeys < ActiveRecord::Migration[7.2]
  def up
    fix_application_fk(:oauth_access_grants, "fk_oauth_access_grants_application_id")
    fix_application_fk(:oauth_access_tokens, "fk_oauth_access_tokens_application_id")

    fix_owner_fk(:oauth_access_grants, "fk_oauth_access_grants_owner_id")
    fix_owner_fk(:oauth_access_tokens, "fk_oauth_access_tokens_owner_id")
  end

  private

  def fix_application_fk(table, fk_name)
    remove_all_fks(table, :application_id, :oauth_applications)
    change_column table, :application_id, :bigint
    add_foreign_key table, :oauth_applications, column: :application_id, name: fk_name
  end

  def fix_owner_fk(table, fk_name)
    # falls bei dir nicht users -> anpassen
    remove_all_fks(table, :resource_owner_id, :users)
    change_column table, :resource_owner_id, :bigint
    add_foreign_key table, :users, column: :resource_owner_id, name: fk_name
  end

  def remove_all_fks(from_table, column, to_table)
    loop do
      fk = connection.foreign_keys(from_table).find do |f|
        f.column.to_s == column.to_s && f.to_table.to_s == to_table.to_s
      end
      break unless fk

      remove_foreign_key from_table, to_table: to_table, column: column
    end
  end
end
