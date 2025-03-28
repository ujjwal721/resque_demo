# app/jobs/my_worker.rb
class MyWorker
    @queue = :default
  
    def self.perform(*args)
      puts "Dynamic job executing with arguments: #{args.inspect}"
      # Yahan aap apna dynamic processing code add kar sakte hain.
    end
  end
  