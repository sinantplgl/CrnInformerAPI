class Api::MainController < ApplicationController
    
    def create
        @user = User.find_by(email: request_params[:email])
        if not @user
            @user = User.create(email: request_params[:email]) 
        end

        if not @user.crns.pluck(:crn).include?(request_params[:crn])
            @crn = Crn.find_by(crn: request_params[:crn])

            if not @crn
                @crn = Crn.create(crn: request_params[:crn])
            end

            @user.crns << @crn

            Request.find_by(user_id: @user.id, crn_id: @crn.id).update(is_active: true)
        else
            @crn = Crn.find_by(crn: request_params[:crn])
            Request.where(user_id: @user.id, crn_id: @crn.id).first.update(is_active: true)
        end
    end

    def check_available
        @result = []
        @user = User.find_by(email: request_params[:email])
        if @user
            @requests = Request.where(user_id: @user.id, is_active: true)
            require 'net/http'
            
            host = 'suis.sabanciuniv.edu'
    
            @requests.each do |req|
                path = "/prod/bwckschd.p_disp_detail_sched?term_in=201901&crn_in=#{req.crn.crn}"
                response = Net::HTTP.get_response(host, path)
                
                begin
                    rem = response.body.split('<td CLASS="dddefault">')[3].split('<')[0].to_i
                    @result << {crn: req.crn.crn, space: rem}
                rescue
                    puts 'couldnt find'
                end
            end
        end

        render json: @result
    end

    def inform_by_mail
        @requests = Request.where(is_active: true)

        @requests.each do |req|
            crn = req.crn
            rem = check_crn(crn)
            if rem && rem > 0
                #send mail to crn.users
                RequestMailer.with(user: req.user, crn: crn).inform_mail.deliver_later
                req.update(is_active: false)
            end
        end
    end
    
    private

    def request_params
        params.permit(:email, :crn)
    end

    def check_crn crn
        require 'net/http'
            
        host = 'suis.sabanciuniv.edu'
        path = "/prod/bwckschd.p_disp_detail_sched?term_in=201901&crn_in=#{crn.crn}"
        
        response = Net::HTTP.get_response(host, path)
        begin
            response.body.split('<td CLASS="dddefault">')[3].split('<')[0].to_i
        rescue
            return nil
        end
    end
end
