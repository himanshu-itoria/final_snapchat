class AnnotatedImage < ApplicationRecord
    has_one_attached :image, dependent: :destroy
    validates :name, presence: true
  
   
    
    def self.image_valid? (image)
      allowed_types = ['image/jpeg', 'image/png', 'image/gif']
      image.image.content_type.in?(allowed_types)
    end
  
  end
   # def self.valid_annotations?(annotations)
    #   # count = 0
    #   # annotations.each do |key, value|
    #   #     count++
    #   #   return false if (key.empty? && !value.empty?) || (value.empty? && !key.empty?) || (key.empty? && value.empty?)||(count>9)
    #   # end
      
    #   # true
    # end