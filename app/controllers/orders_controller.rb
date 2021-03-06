#require 'pdf/writer'
require 'pdfkit'

class OrdersController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create]

  # GET /orders
  # GET /orders.xml
  def index
    #@orders = Order.all
    @orders = Order.paginate :page=>params[:page], :order=> 'created_at desc', :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @cart = current_cart

    if @cart.line_items.empty?
      respond_to do |format|
        format.html { redirect_to store_url, :notice => 'Your cart is empty' }
        format.xml { head :ok }
      end
      return
    end

    @order = Order.new
    @checking_out = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)

    respond_to do |format|
      if @order.save

        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        Notifier.order_received(@order).deliver

        #format.html { redirect_to(@order, :notice => 'Order was successfully created.') }
        format.html { redirect_to(store_url, :notice => I18n.t('.thanks') ) } #'Thank you for your order.') }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end

  def ship_order
    @order = Order.find(params[:id])

    if @order.ship_date
      respond_to do |format|
        format.html { redirect_to store_url, :notice => 'The chosen order has already been shipped' }
        format.xml { head :ok }
      end
      return
    end

    @order.ship_date = Time.now
    @order.save

    Notifier.order_shipped(@order).deliver

    respond_to do |format|
      format.html { redirect_to store_url, :notice => "#{@order.name}'s order has been shipped."}
      format.xml { head :ok }
    end
  end

  def pdf
    @order = Order.find(params[:id])

    rnd = render_to_string('_pdf', :layout => false)
    kit = PDFKit.new(rnd, :page_size => 'Letter')
    #kit.stylesheets << "#{Rails.root}/public/stylesheets/depot.css"
    send_data(kit.to_pdf, :filename => "order_no_#{@order.id}.pdf", :type => 'application/pdf', :disposition => 'inline')

=begin
    _p = PDF::Writer.new
    _p.select_font 'Times-Roman'
    _p.text "Hello, Ruby.", :font_size => 72, :justification => :center
    send_data _p.render, :filename => 'lol.pdf', :type => "application/pdf"
=end
  end
end
