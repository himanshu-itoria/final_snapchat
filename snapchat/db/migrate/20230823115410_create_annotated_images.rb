class CreateAnnotatedImages < ActiveRecord::Migration[6.0]
  def change
    create_table :annotated_images do |t|
      t.json :annotations, null: false, default: '{}'
      t.timestamps
    end
  end
end
