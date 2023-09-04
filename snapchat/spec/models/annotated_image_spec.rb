require 'rails_helper'

RSpec.describe AnnotatedImage, type: :model do
  describe "validations" do
    it "is valid with a name" do
      annotated_image = FactoryBot.build(:annotated_image, name: "Sample Image")
      expect(annotated_image).to be_valid
    end
    context "with empty name" do
      #       it "redirects to edit with a failure flash message" do
      #         new_nam = "_"
      #         patch :update, params: { id: image.id,  name: new_nam , custom_keys: image.annotations.keys, custom_values: image.annotations.values }
              
      #         image.reload
      #         expect(image.reload.name).to eq("_")
      #         expect(flash[:alert]).to eq('Image name cannot be empty')
      #         expect(response).to redirect_to(edit_annotated_image_path(image))
               
      #       end
      #     end

    it "is invalid without a name" do
      annotated_image = FactoryBot.build(:annotated_image, name: nil)
      expect(annotated_image).to be_invalid
      expect(annotated_image.errors[:name]).to include("can't be blank")
    end
  end

  describe ".image_valid?" do
    let(:jpeg_image) { FactoryBot.build(:annotated_image, image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg')) }
    let(:png_image) { FactoryBot.build(:annotated_image, image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.png'), 'image/png')) }
    let(:gif_image) { FactoryBot.build(:annotated_image, image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.gif'), 'image/gif')) }
    let(:invalid_image) { FactoryBot.build(:annotated_image, image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.txt'), 'text/plain')) }

    it "returns true for valid image types" do
      expect(AnnotatedImage.image_valid?(jpeg_image)).to be true
      expect(AnnotatedImage.image_valid?(png_image)).to be true
      expect(AnnotatedImage.image_valid?(gif_image)).to be true
    end

    it "returns false for invalid image types" do
      expect(AnnotatedImage.image_valid?(invalid_image)).to be false
    end
  end
end
end