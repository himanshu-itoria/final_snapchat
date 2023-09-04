require 'rails_helper'

RSpec.describe AnnotatedImagesController, type: :controller do
  describe "GET #index" do
    it "assigns all annotated images to @annotated_images" do
      annotated_image1 = FactoryBot.create(:annotated_image)
      annotated_image2 = FactoryBot.create(:annotated_image)

      get :index
      expect(assigns(:annotated_images)).to match_array([annotated_image1, annotated_image2])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new annotated image" do
        expect {
          post :create, params: { name: "Test Image", image: fixture_file_upload("test.jpg") }
        }.to change(AnnotatedImage, :count).by(1)

        expect(response).to redirect_to(annotated_images_path)
        expect(flash[:notice]).to eq('Image was successfully uploaded.')
      end
    end
        
    context "with invalid parameters" do
      it "renders the new template" do
        post :create, params: { name: "", image: nil }
        expect(response).to render_template(:new)
      end
    end
  end

 
  describe "PATCH #update" do
    let(:image) { FactoryBot.create(:annotated_image) }
    # byebug

    context "with valid parameters" do
      it "updates the image attributes" do
        new_name = "New Name"
        patch :update, params: { id: image.id, name: new_name , custom_keys: image.annotations.keys, custom_values: image.annotations.values }
        # patch :update, params: { id: image.id,  name: new_name  }
    #  byebug
        image.reload
        expect(image.reload.id).to eq(1)
        # byebug
        expect(image.reload.name).to eq("New Name")
      
        expect(image.annotations).to eq({ "key1" => "value1", "key2" => "value2" })
        expect(response).to redirect_to(annotated_images_path)
        expect(flash[:notice]).to eq('image is updated successfully.')
      end
    end
    # context "with empty name" do
    #       it "redirects to edit with a failure flash message" do
    #         new_nam = "_"
    #         patch :update, params: { id: image.id,  name: new_nam , custom_keys: image.annotations.keys, custom_values: image.annotations.values }
            
    #         image.reload
    #         expect(image.reload.name).to eq("_")
    #         expect(flash[:alert]).to eq('Image name cannot be empty')
    #         expect(response).to redirect_to(edit_annotated_image_path(image))
             
    #       end
    #     end
    
    context "valid image type" do
         it "validates if the image is in valid format" do
          #  new_nam ="abc.pdf"
          abc = fixture_file_upload("Banking.pdf")
           patch :update, params: {id: image.id, name: "Test Image", image: abc,custom_keys: image.annotations.keys, custom_values: image.annotations.values }
           image.reload
          #  expect(image.reload.name).to eq("abc.pdf")
           expect(flash[:alert]).to eq('Only image files (jpg, jpeg, png, gif) are allowed')
         end
        end
end
describe "GET #edit_annotation" do
let(:image) { FactoryBot.create(:annotated_image) }

    it "returns a successful response" do
      get :edit_annotation, params: { id: image.id }
      expect(response).to have_http_status(:success)
    end

end
describe "PATCH #update_annotation" do
    let(:image) { FactoryBot.create(:annotated_image) }

    context "with valid annotations" do
      it "updates the annotations and shows a success flash message" do
        valid_annotations = { "key1" => "value1", "key2" => "value2" }

        patch :update_annotation,format: :js, params: {
          id: image.id,
          custom_keys: valid_annotations.keys,
          custom_values: valid_annotations.values
        }

        image.reload
        expect(image.annotations).to eq(valid_annotations)
        expect(response).to have_http_status(:success)
        expect(flash.now[:notice]).to eq('Annotations updated successfully.')
      end
    end
  
    context "with empty annotations" do
      it "does not update annotations and shows an alert flash message" do
        patch :update_annotation,format: :js, params: { id: image.id, custom_keys: [], custom_values: [] }

        image.reload
        expect(image.annotations).to be_empty
        expect(response).to have_http_status(:success)
        expect(flash.now[:alert]).to eq(nil)
      end
    end

    context "with invalid annotations" do
      it "does not update annotations and shows an alert flash message" do
        invalid_annotations = { "key1" => "" }

        patch :update_annotation,format: :js, params: {
          id: image.id,
          custom_keys: invalid_annotations.keys,
          custom_values: invalid_annotations.values
        }

        image.reload
        expect(image.annotations).to eq({"key1"=>""})
        expect(response).to have_http_status(:success)
        expect(flash.now[:alert]).to eq(nil)
      end
    end
  end
describe "DELETE #destroy" do
let!(:image) { FactoryBot.create(:annotated_image) }

it "destroys the image and redirects to annotated_images_path" do
  expect {
    delete :destroy, params: { id: image.id }
  }.to change(AnnotatedImage, :count).by(-1)

  expect(response).to redirect_to(annotated_images_path)
end
end


end

# require 'rails_helper'

# RSpec.describe AnnotatedImagesController, type: :controller do
#         describe "POST #create" do
#         context "with valid parameters" do
#         it "creates a new annotated image" do
#             expect {
#               post :create, params: { name: "Test Image", image: fixture_file_upload("test_image.jpg") }
#           }.to change(AnnotatedImage, :count).by(1)

#           expect(response).to redirect_to(annotated_images_path)
#               expect(flash[:notice]).to eq('Image was successfully uploaded.')
#          end
#            end
  
#           context "with invalid parameters" do
#         it "renders the new template" do
#           post :create, params: { name: "", image: nil }
#            expect(response).to render_template(:new)
#         end
#          end
#        end
  
#   describe "private methods" do
#     let(:image) { FactoryBot.create(:annotated_image) }

#     describe "#image_params" do
#       it "permits the expected parameters" do
#         params = ActionController::Parameters.new(name: "Test Image", image: fixture_file_upload("test_image.jpg"))
#         permitted_params = controller.send(:image_params)
#         byebug
#         permitted_params.add(:name,:image)
#         byebug
#         expect(permitted_params).to include(:name, :image)
#         expect(permitted_params).not_to include(:other_param)
#       end
#     end

#     describe "#set_image" do
#       it "finds and assigns the correct image" do
#         get :show, params: { id: image.id }
#         expect(assigns(:image)).to eq(image)
#       end
#     end

#     describe "#set_annotation" do
#       it "returns a hash of custom_keys and custom_values" do
#         custom_keys = ["key1", "key2"]
#         custom_values = ["value1", "value2"]

#         allow(controller).to receive(:params).and_return(custom_keys: custom_keys, custom_values: custom_values)

#         result = controller.send(:set_annotation)

#         expect(result).to eq({ "key1" => "value1", "key2" => "value2" })
#       end

#       it "returns an empty hash when custom_keys and custom_values are not provided" do
#         allow(controller).to receive(:params).and_return({})

#         result = controller.send(:set_annotation)

#         expect(result).to eq({})
#       end
#     end
#   end
# end

# require 'rails_helper'

# RSpec.describe AnnotatedImagesController, type: :controller do
#        describe "POST #create" do
#        context "with valid parameters" do
#       it "creates a new annotated image" do
#           expect {
#           post :create, params: { name: "Test Image", image: fixture_file_upload("test_image.jpg") }
#         }.to change(AnnotatedImage, :count).by(1)

#         expect(response).to redirect_to(annotated_images_path)
#         expect(flash[:notice]).to eq('Image was successfully uploaded.')
#           end
#          end

#          context "with invalid parameters" do
#           it "renders the new template" do
#         post :create, params: { name: "", image: nil }
#         expect(response).to render_template(:new)
#           end
#          end
#              end

#   describe "PATCH #update" do
#     let(:image) { FactoryBot.create(:annotated_image ) }

#     context "with valid parameters" do
#       it "updates the image attributes" do
#         patch :update, params: { id: image.id, name: "New Name" } 
#          image.reload
#         # byebug
#         expect(image.name).to eq("New Name")
#         expect(response).to redirect_to(annotated_images_path)
#                expect(flash[:notice]).to eq('Image is updated successfully.')
#             end
#                end

#     context "with invalid parameters" do
#       it "redirects to edit with a failure flash message" do
#         patch :update, params: { id: image.id, annotated_image: { name: "" } }
#         expect(response).to redirect_to(edit_annotated_image_path(image))
#         expect(flash[:alert]).to eq('Keys and values must be present')
#        end
#         end
#             end

#   # Add more test cases for other actions
# end
 # describe "PATCH #update" do
  #   let(:image) { FactoryBot.create(:annotated_image) }

  #   context "with valid parameters" do
  #     it "updates the image attributes" do
  #       byebug
  #       patch :update, params: { id: image.id, annotated_image: { name: "New Name" } }
  #     image.reload
  #       expect(image.name).to eq("New Name")
  #      expect(response).to redirect_to(annotated_images_path)
  #       expect(flash[:notice]).to eq('Image is updated successfully.')
  #        end
  #       end

  #   context "with invalid parameters" do
  #     it "redirects to edit with a failure flash message" do
  #     patch :update, params: { id: image.id, annotated_image: { name: "" } }
  #      expect(response).to redirect_to(edit_annotated_image_path(image))
  #      expect(flash[:alert]).to eq('not updated')
  #     end
  #      end
  #      end
  # RSpec.describe AnnotatedImagesController, type: :controller do
    # describe "PATCH #update" do
    #   let(:image) { FactoryBot.create(:annotated_image) }
  
    #   context "with valid parameters" do
    #     it "updates the image attributes" do
    #       patch :update, params: { id: image.id, annotated_image: { name: "New Name" } }
    #       image.reload
    #       expect(image.name).to eq("New Name")
    #       expect(response).to redirect_to(annotated_images_path)
    #         expect(flash[:notice]).to eq('Image is updated successfully.')
    #        end
    #         end
  
    #   context "with invalid parameters" do
    #     it "redirects to edit with a failure flash message" do
    #       patch :update, params: { id: image.id, annotated_image: { name: "" } }
    #       expect(response).to redirect_to(edit_annotated_image_path(image))
    #       expect(flash[:alert]).to eq('not updated')
    #          end
    #          end
  
    #   context "with valid annotations" do
    #     it "updates the annotations" do
    #       valid_annotations = { "key1" => "value1", "key2" => "value2" }
    #       patch :update, params: { id: image.id, annotated_image: { name: "New Name" }, custom_keys: valid_annotations.keys, custom_values: valid_annotations.values }
          
    #       image.reload
    #        expect(image.name).to eq("New Name")
    #             expect(image.annotations).to eq(valid_annotations)
    #            expect(response).to redirect_to(annotated_images_path)
    #             expect(flash[:notice]).to eq('Image is updated successfully.')
    #             end
    #             end
    # end
  #   