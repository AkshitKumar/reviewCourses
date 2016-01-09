class AdminMail < ApplicationMailer
    def review_mail(course,user)
          @user = user
          @course=course
        mail( :to => "sac_speaker@smail.iitm.ac.in",
    :subject => "#{@user['fullname'].titleize}Review on Course" )
    end
end
