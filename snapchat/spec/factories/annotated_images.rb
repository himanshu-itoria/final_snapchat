# spec/factories/annotated_images.rb

# FactoryBot.define do
#     factory :annotated_image do
#       name { "Sample Image" }
#       image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg') }
#     end
#   end
  
FactoryBot.define do
    factory :annotated_image do
      name { "Sample Image" }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg') }
      annotations { { "key1" => "value1", "key2" => "value2" } }
    end
    # factory :empty_image do
    #   name { "" }
    #   image {Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/abc.jpg'), 'image/jpeg')}
    #   annotations { { "key1" => "value1", "key2" => "value2" } }
    # end
  end
  