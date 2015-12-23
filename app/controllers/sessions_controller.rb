class SessionsController < ApplicationController
	require 'rubygems'
	require 'net/ldap'
	
	def create
		roll_no = params[:session][:roll_no]
		password = params[:session][:password]
		if !roll_no.match(/[a-zA-Z]{2}[0-9]{2}[a-zA-Z]{1}[0-9]{3}/)
    	redirect_to root_path
    	flash[:error] = "Sorry, such a user does not exist in our database."
		else
  		ldap = Net::LDAP.new :host => 'ldap.iitm.ac.in',
			:port => 389,
    	:auth => {
						:method => :simple,
						:username => "cn=students,ou=bind,dc=ldap,dc=iitm,dc=ac,dc=in",
						:password => "rE11Bg_oO~iC"
								}
			if ldap.bind
				filter = Net::LDAP::Filter.eq("uid", roll_no)
				treebase = "dc=ldap, dc=iitm, dc=ac, dc=in"
    		ldap.search( :base => treebase,:filter => filter ) do |entry|
					puts "DN: #{entry.dn}"
            if entry.dn
              ldap1 = Net::LDAP.new
              ldap1.host = "ldap.iitm.ac.in"
              ldap1.port = 389
              ldap1.auth entry.dn, password
              if ldap1.bind
                @user = User.find_by(username: params[:session][:roll_no])
                if @user
                  log_in @user
							#		render :html => @user.fullname
                  redirect_to root_path
                  flash[:success] = "Welcome, #{@user[:fullname]}"
                else
                  redirect_to root_path
                	flash[:error] = "Sorry, such a user does not exist in our database."
                end
              else
		 						redirect_to root_path, :flash => { error: "Invalid username or password" }
              end
            end
  			end
			end
		end
	end

	def destroy
		#raise log_out.inspect
	#	render root_path
		log_out
		redirect_to root_path
	end

end
