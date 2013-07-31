class Content < ActiveRecord::Base
  
  # #include ActionView::Helpers
  # include ApplicationController.helpers.name_visible?
   # before_save :name_visible?
   
  acts_as_taggable_on :tags
  
  make_flaggable :upvote
  
  scope :sorted, order('contents.title ASC')
  scope :privacy, where(:privacy => true)
  
  # attr_accessible :title, :body
  belongs_to :folder
  attr_accessible :title, :file_type, :content_type, :privacy, :link, :description, :user_id, :avatar, :name, :tag_list, :upvotes, :quote, :publishedBy, :dailyupvotes
  
  
  searchable do
    text :title
    integer :user_id
    integer :upvotes
    time :created_at
    time :updated_at
    boolean :privacy
    boolean :name
    string :tag_list, :multiple => true, :stored => true
  end
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  
  no_whitespace = /^[\S]+$/
  
  # validates_length_of :description, :maximum => 200, :message => "Please limit the description to 200 characters."
  validates :content_type, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true
  validates :tag_list, :presence => true#,:format => no_whitespace
  # validates_format_of :link, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
   validates_attachment_content_type :avatar,
     :content_type => ['image/png', 'image/jpeg', 'image/jpg', 'image/gif'],  :message => "Not a valid image file (jpg, jpeg, png, gif)",
     :if => :is_type_of_image?    
     
     protected
  def is_type_of_image?
    avatar.content_type =~ %r(image)
  end
  
  
  
  # def name_visible?
    # user=User.find(session[:user_id])
    # if self.name==true || self.name= "t"
      # self.name="Anonymous"
    # else
      # self.name="#{user.first_name} #{user.last_name}"
    # end
  # end

def self.resetDailyUp
 contents=Content.all
 contents.each do |content|
   content.update_attributes(:dailyupvotes=>0)
 end
end


end
