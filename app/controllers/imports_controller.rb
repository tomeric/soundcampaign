class ImportsController < ApplicationController
  
  before_filter :load_context,
    except: %i[ index ]
  
  def index
    redirect_to action: 'new'
  end
  
  def show
    redirect_to action: 'prepare'
  end
  
  def new
    @import = @context.imports.new
  end
  
  def create
    @import = @context.imports.build(import_params)
    
    if @import.save
      redirect_to [:prepare, @context, @import]
    else
      render 'new'
    end
  end
  
  def prepare
    @import   = @context.imports.find(params[:id])
    @mappable = @context.imports.mappings.keys
    @rows     = @import.rows.limit(20)
  end
  
  def execute
    @import = @context.imports.find(params[:id])
    
    processor = Import::RowProcessor.new(
      @import.rows,
      column_settings: column_settings,
      row_settings:    row_settings
    )
    
    statuses = []
    processor.each_row do |attributes|
      statuses << @context.imports.process(attributes)
    end
    
    redirect_to @context
  end
  
  private
  
  def column_settings
    hash_to_indexed_array params[:column]
  end
  
  def row_settings
    hash_to_indexed_array params[:row]
  end
  
  def import_params
    params.require(:import)
          .permit(:spreadsheet)
  end
  
  def load_context
    if params[:contact_list_id]
      @context = current_organization.contact_lists.find(params[:contact_list_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
end
