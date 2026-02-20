class FixDuplicateTitleOnSnapshots < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:snapshots, :title)
      add_column :snapshots, :title, :string
    end
  end
end
