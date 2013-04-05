class LabelsController < ApplicationController
  
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  
  def index
    @labels = Label.all
  end
  
  def show
  end
  
  def new
    @label = Label.new
  end
  
  def edit
  end
  
  def create
    @label = Label.new(label_params)
    
    if @label.save
      redirect_to @label, notice: 'Label was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @label.update(label_params)
      redirect_to @label, notice: 'Label was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @label.destroy
    redirect_to labels_url, notice: 'Label was successfully destroyed.'
  end
  
  private
  
  def set_label
    @label = Label.find(params[:id])
  end
  
  def label_params
    params.require(:label)
          .permit(:name, :description, :catid, :style, :cover,
                  :contact_name,   :contact_email, :contact_zipcode_city,
                  :contact_street, :contact_phone, :contact_url)
    
  end
end