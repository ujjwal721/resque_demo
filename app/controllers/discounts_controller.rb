class DiscountsController < ApplicationController
    def schedule_discount
      Resque.enqueue_in(3.hours, NonGoldDiscountJob)
      
      render json: { message: "Non-gold discount job scheduled to run in 3 hours." }
    end
  end
  