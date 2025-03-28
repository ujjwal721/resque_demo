# Defines a new controller name NotificationController inherited from ApplicationController
class NotificationController<ApplicationController
    #Skips the prefilter method for email unsubsribe actions
    skip_before_action : :prefilter, :only => [:email_unsubscribe,:confirm_email_unsubscribe,:subscribe_email_back] 
    skip_before_action : :global_before_filter , :only => [:create_big_pic,:fetch_big_pic,:fetch_big_pic_v3]
    skip_after_action : :global_after_filter , :only => [:create_big_pic,:fetch_big_pic,:fetch_big_pic_v3]
     
    #defines the prefilter method that checks for user authentication
    def prefilter remove_params = false
        if current_authenticated_user.nil? #Checks if there is no authenticated user
            if remove_params # if remove_params is true,will strip query parameters from url
                request.env["REQUEST_URI"] = request.env["REQUEST_URI"].to_s.split("?")[0] 
                # Gets the current request URI convert it to string,spilts at the '?' character and takes the first part
            respond_to do |format| # set up responses based on the request format (HTML or JSON)
                format.html {redirect_to get_server_lname +'/signin?ret='+request.env["REQUEST_URI"] and return}
                format.json {render:json => {"status"=>"fail","reason"=>"user not authenticated"},:status =>403 and return}
            end
        end
    end
    # defines the method to handle the notification unsubscribe action
    def notification_unsubscibe
        #set up responses based on the request format 
        request_to do |format|
            format.html {render :layout => "feed", :template => "notification/unsubscribe" and return}
        end
    end
    
    def log_event event_name #defines a method to log notification event and takes one parameter event_name
        ev_hash = {} #Create an empty hash to store event data
        ev_hash[:ev_name] = event_name #Assign the event name to the hash
        #Adds parameter from the request to the hash
        ev_hash[:do_value] = params["do_val"]
        ev_hash[:do_type] = params["do_type"]
        ev_hash[:df_type] = params["df_type"]
        ev_hash[:do_extra] = params["do_extra"]

    if params["uuid"].present? #Checks if the uuid parameter is present
        ev_hash[:db_val] = params["uuid"] # Assign it to hash as db_val
    end
    
    #Creates a new event object with the hash data and pushes this event to global activity logger object for tracking
    ACTIVITY_LOGGER.push Event.new(ev_hash)
end

    def confirm_unsubscribe
        log_event "smsOptOut" #Logs the event smsOptOut
        render :json => {:status=>'confirm_unsubscribe'} and return
    end

    def subscribe_back 
        log_event "smsOptBackIn" #Logs the event smsOptBackIn
        render:json => {"status" => 'subscribe_back'} and return
    end

    #defines a method to extract user information from subscription and unsubscription parameters
    def get_user_subunsub
        params.delete("uuid") #Removes the uuid parameter to prevent from spoofing
        if params["do_val"].present? && params["do_type"].present? && params["df_type"].present? #Checks if the required parameters are present
            notification_type = params["do_type"]
            notiification_category = params["df_type"]
            #Gets the encrypted email from the do_val parameter and decrypts it using Notification class method
            email = Notification.decrypt((params["do_val"].split('?')[0]))
            #If the email contains the colon splits it and takes the first part
            #This will remove the timestamp from the email
            email = email.split(":")[0] if email.present? && email.include?(":")
            if email.present?
                userObj = User.get_user_by_email(email) #Gets the user object by email
                params["uuid"] = userObj["uuid"] if userObj != -1 && userObj.present?
            end
        end
    end

    #defines a method to handle email unsubscribe page display
    def email_unsubscribe
        get_user_subunsub #Calls the get_user_subunsub method to extract user information
        if params["uuid"].present?
            render:action => "email_unsubscribe" and return
        end
        prefilter(true) #Calls the prefilter method to check for user authentication
    end

    #defines a method to handle email unsubscribe confirmation
    def confirm_email_unsubscribe
        get_user_subunsub #Calls the get_user_subunsub method to extract user information
        if params["uuid"].present?
            if User.is_user_subscribed(params["do_type"],params["df_type"],params["uuid"]) #Checks if the user is subscribed
                log_event "emailOptOut" #Logs the event emailOptOut
                if User.notif_unsubscribe(params["uuid"],params["do_type"],params["df_type"])
                    log_event "emailOptOut_200" #Logs the event emailOptOut_200
                    render:json => {:code => 200,:status => 'You have successfully unsubscribed'} and return
                else #Unsubscription failed
                    log_event "emailOptOut_Non200"
                    render:json =>{:code => 500,:status => 'Unsubscription failed'} and return
                end
            else #if user is not subscribed
                render:json => {:code => 500, :status => 'You are not subscribed to Limeroad email address'} and return
            end
        else # if no UUID is present
            log_event "emailOptOut"
            render:json {:code=>200 ,:status => 'You have successfully unsubscribed'} and return
    end
end

#This method provides the user,browser and device information to notification parameters
    def add_common_params params
        if params.present?
            params[:ruid] = get_ruid
            params[:user_type]=get_user_type
            params[:origin_base]=get_call_base_origin
            params[:os_type]=get_call_os
            params[:origin_browser]=get_call_browser
            params[:origin_browser_version]=get_call_browser_version
            
        if current_authenticated_user.present?
            params[:email] = current_authenticated_user.email if current_authenticated_user.email.present?
            params[:uuid] = current_authenticated_user.uuid if current_authenticated_user.uuid.present?
        end
    end
end

    def create_big_pic
        #Initiliazes an empty hash called @temp_data as an instance variable
        @temp_data = {}
        temp_id = params[:temp_id]
        prod_id = params[:prod_id]
        if (prod_id.present?)
            product = Product.get_uip_static_data(prod_id)
            product = JSON.parse(product)
            image_url = UiHelper.get_product_image_url(prod_id,product['fileidn'], res_type: 'zoom', img_pos: 0, protocol: 'none')
            temp_data = {"text" => product["classification"].split("/").last.humanize.upcase, "image_url" => image_url }

    end
end

1. color_data_missing - The function get_rail_color is trying to retrieve color data from a database
using both data-based and day-based keys.
The event color_data_missing is logged in 3 different scenarios - 
(i) When both the date-based and day-based color data are missing (aspk_data[0].nil? && aspk_data[1].nil?)
(ii) When only the date-based color data is missing (aspk_data[0].nil?)
(iii) When only the day-based color data is missing (aspk_data[1].nil?)
This logging helps track when and why color data might be unavailable, which could be important.
Without this event logging, if colors aren't appearing correctly in the application, you would 
have no way to trace whether it's because the data is missing or because of some other issue in the application.

2.

