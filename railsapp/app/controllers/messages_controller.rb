class MessagesController < ApplicationController
  
  before_filter :ensure_post, :only => [:queue_send, :topic_send, :fanout_send]

  def queue_send
    msg = {:ary => [1,2,3], :date => Time.new, :type => "Order", :name => rand(0x100000000)}.to_json
    Qusion.channel.queue("orders").publish(msg)
    flash[:notice] = "Message <code>#{msg}</code> sent to exchange: 'amq.topic'"
    redirect_to :action => :queue
  end

  def topic_send
    msg = params[:stock].to_json
    routing_key = params[:stock][:stock]
    Qusion.channel.topic("stocks").publish(msg, :key => routing_key)
    flash[:notice] = "Message <code>#{msg}</code> sent to exchange: 'stocks' using routing key <strong>#{routing_key}</strong>"
    redirect_to :action => :topic
  end
  
  def fanout_send
    msg = "This is an example broadcast message"
    Qusion.channel.fanout("alerts").publish(msg)
    flash[:notice] = "Message <code>#{msg}</code> sent to fanout exchange: 'alerts'"
    redirect_to :action => :fanout
  end
  
  def topic
    @stocks = [['Apple (us)', 'stock.us.appl'], 
      ['Sun (us)', 'stock.us.java'], 
      ['Google (us)', 'stock.us.goog'], 
      ['Adidas (de)', 'stock.de.ads'],
      ['Deutsche Lufthanse (de)', 'stock.de.lha'],
    ]
  end
  
  private
    def ensure_post
      show = action_name.gsub(/_send$/, '').to_sym
      logger.debug "Before action #{action_name}"
      redirect_to :action => show unless request.post?
    end
  
end
