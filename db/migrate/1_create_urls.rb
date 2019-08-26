class CreateUrls <  ActiveRecord::Migration[5.2]

  def change
    create_table(:urls) do |t|
      t.string :url_key
      t.string :full_url
      t.datetime :last_accessed
      t.integer :times_viewed, default: 0

      t.timestamps
    end
  end
end
