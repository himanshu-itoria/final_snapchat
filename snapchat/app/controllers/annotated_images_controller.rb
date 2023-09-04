class AnnotatedImagesController < ApplicationController
    before_action :set_image, only: %i[edit update show destroy update_annotation edit_annotation]
    # before_action :set_prev_and_next_image, only: [:show]
  
    def index
      @annotated_images = AnnotatedImage.all
    end
  
    def create
      @image = AnnotatedImage.new(image_params)
      @image.annotations = set_annotation
  
     if @image.save
        redirect_to annotated_images_path, notice: 'Image was successfully uploaded.'
      else
        flash[:alert] = 'Failed to save image'
        render :new
      end
    end
  
    def update
      #  byebug
      @image.annotations = set_annotation
      @image.image = params[:image] if params[:image]

      # byebug
      if img_checks
        # byebug
        redirect_to edit_annotated_image_path(@image)
      elsif @image.update(image_params) 
        # byebug
        flash[:notice] = 'image is updated successfully.'
        redirect_to annotated_images_path
      # else
      #   flash[:alert] = 'not updated'
      #   # byebug
      #   redirect_to edit_annotated_image_path(@image)
      end
    end
  
    def update_annotation
      @image.annotations = set_annotation
      
      if @image.save
        respond_to do |format|
          format.js { flash.now[:notice] = 'Annotations updated successfully.' }
        end
      # elsif
      #   respond_to do |format|
      #     format.js { flash[:alert] = 'Failed to update annotations.' }
      #   end
      end
    end
  # if !AnnotatedImage.valid_annotations? @image.annotations
  #       respond_to do |format|
  #         format.js { flash.now[:alert] = 'Keys and values must be present' }
  #       end
    def destroy
      @image.destroy
      redirect_to annotated_images_path
    end
  
    def edit_annotation; end
  
    # def show; end
  
    def edit; end
  
    private
  
    def img_checks
      if @image.name.empty?
        flash[:alert] = 'Image name cannot be empty'
        # byebug
        return true
      end
      
      unless @image.image.attached?
        flash[:alert] = 'Image is not attached'
        # byebug
        return true
      end
  
      unless AnnotatedImage.image_valid?(@image)
        flash[:alert] = 'Only image files (jpg, jpeg, png, gif) are allowed'
        return true
      end
  
  
      # unless AnnotatedImage.valid_annotations?(@image.annotations)
      #   flash[:alert] = 'Keys and values must be present'
      #   return true
      # end
  # byebug
      false
    end
  
    def image_params
      params.permit(:name, :image)
    end
  
    def set_image
      @image = AnnotatedImage.find(params[:id])
    end
  
    def set_annotation
      if params[:custom_keys] && params[:custom_values] && !params[:custom_keys].empty?
        custom_keys = params[:custom_keys]
        custom_values = params[:custom_values]
        custom_keys.zip(custom_values).to_h
      else
        {}.to_h
      end
    end
  end
  
