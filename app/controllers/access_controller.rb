class AccessController < ApplicationController
  before_filter :confirm_logged_in, :except => [:attempt_login, :logout, :index,:register,:createuser,:activate,:resendtoken,:confirmtoken, :sendpasstoken, :resetpassword, :confirmNewToken, :confirmedNowNewPassword]
  before_filter :current_user
  
  def index
    #display login form
  end
  
  def register
    @user=User.new
  end
  
  def createuser
    #Instantiate a new object using form parameters
    @user= User.new(params[:user])
    #@user.activated=false
    #Save the object
    if @user.save
      #If save succeeds redirect to the list action
      UserMailer.registration_confirmation(@user).deliver
      flash[:notice]="Email Activation Sent."
      redirect_to(:action => 'activate')
    else
      #If save fails, redisplay the form so user can fix problems
      render('register')
    end
  end
  
  def attempt_login
    authorized_user = User.authenticate(params[:email], params[:password])
    if !authorized_user
      flash[:error] = "Invalid email/password combination."
      redirect_to(:action => 'index')
    elsif authorized_user && authorized_user.activated == false || authorized_user.activated == "f"
       flash[:error] = "You have not activated your account"
       redirect_to(:action => 'activate')
    elsif authorized_user && authorized_user.activated == true || authorized_user.activated == "t"
      session[:user_id]=authorized_user.id
      session[:email]=authorized_user.email
      # flash[:notice] = "You are logged in"
      redirect_to(:controller => 'explore', :action => 'editorspicks',:user_id=>authorized_user.id)
    end 
  end
  
  def logout
      session[:user_id]=nil
      session[:email]=nil
      flash[:notice] = "Logged Out"
      redirect_to(:action => 'index')
  end
  
  def activate
    
  end
  
  def resendtoken
    @user=User.find_by_email(params[:email])
    if @user
      UserMailer.registration_confirmation(@user).deliver
      flash[:notice]="Resent Email"
      redirect_to(:action => 'activate')
    else
      flash[:error]="This email has not been used for registration. Please verify your email and try again."
      render('activate')
    end      
  end
  
  def confirmtoken
    activate_user = User.activate(params[:token])
    if activate_user
      activate_user.activated = true
      activate_user.save
      flash[:notice]="Account Activated"
      redirect_to(:action => 'index')
    else
      flash[:error]="Invalid Token"
      redirect_to(:action => 'activate')
    end
  end
  
  def sendpasstoken #when user forgets password
    @user=User.find_by_email(params[:email])
    if @user
      @user.save
      UserMailer.reset_password(@user).deliver
      flash[:notice]="Please check your email for your confirmation token"
      redirect_to(:action => 'resetpassword')
    else
      flash[:error]="This email has not been used for registration. Please verify your email and try again."
      redirect_to(:action => 'resetpassword')
    end      
  end
  
  def confirmNewToken
    @activate_user = User.activate(params[:token])
    if @activate_user
      flash[:notice]="Thank you for entering your token. Reset your password below."
      render('newpassword')
    else
      flash[:error]="Invalid token. Please enter your email for a new token."
      redirect_to(:action => 'resetpassword')
    end
  end
  
  # def newpassword
    # @user = User.find(params[:id])
#     
  # end
  
  def confirmedNowNewPassword
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice]="Your password has been reset successfully. Please log in."
      redirect_to(:controller => 'access', :action => 'index')
    else
      #If save fails, redisplay the form so user can fix problems
      flash[:error]="Your passwords did not match. Please try again."
      redirect_to(:action => 'confirmNewToken', :token => @user.token)
    end
  end
  
  
  
end