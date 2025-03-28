
class NonGoldDiscountJob
    @queue = :discounts  # You can choose a queue name; here it's "discounts"
  
    def self.perform
      # Fetch all non-gold users. Assuming you have a User model with a boolean column "gold_member"
      users = User.where(gold_member: false)
      
      users.find_each do |user|
        # Apply a 15% discount logic.
        # For example, update a discount_percentage attribute in the User model.
        user.update(discount_percentage: 15)
        
        # Optionally, send a notification or log the update
        Rails.logger.info "Applied 15% discount to User #{user.id}"
      end
      
      Rails.logger.info "NonGoldDiscountJob completed for all non-gold users."
    end
  end
  