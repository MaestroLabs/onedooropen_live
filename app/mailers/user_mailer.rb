class UserMailer < ActionMailer::Base
  def registration_confirmation(user) 
   @user = user
   mail(:from => "noreply@maestro-labs.com", :to => user.email, :subject => "Welcome to OneDoorOpen, #{user.first_name}!")
  end 
  
  def reset_password(user) 
   @user = user
   mail(:from => "noreply@maestro-labs.com", :to => user.email, :subject => "OneDoorOpen | Reset your password, #{user.first_name}!")
  end 
end
