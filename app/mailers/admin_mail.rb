class AdminMail < ApplicationMailer
    def review_mail(course,user)
          @user = User.find_by_id(user)
          @course= Course.find_by_id(course)
        mail( :to => "sac_speaker@smail.iitm.ac.in",
    :subject => "Course Review by #{@user['fullname'].titleize}" )
    end
end
