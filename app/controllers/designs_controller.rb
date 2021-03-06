class DesignsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:designer_id]
      set_designer
      @designs = @designer.designs
      flash[:notice] = "Name of the Designer: #{@designer.name.upcase}"
    elsif params[:fashion_show_id]
      set_fashion_show
      @designs = @fashion_show.designs
      flash[:notice] = "Title of the Fashion Show: #{@fashion_show.title.upcase}"
    else
      @designs = Design.all
    end
  end

  def new
    if params.include?('fashion_show_id')
      set_fashion_show
      @design = @fashion_show.designs.build
    elsif params.include?('designer_id')
      set_designer
      @design = @designer.designs.build
    end
  end

  def create
    if params[:fashion_show_id] 
      set_fashion_show
      @design = @fashion_show.designs.build(design_params)
      if @design.save
        redirect_to fashion_show_path(@fashion_show)
      else
        render 'designs/new'
      end
    elsif params.include?('designer_id')
      set_designer
      @design = Design.new(design_params)
      if @design.save
        redirect_to designer_path(@designer)
      else
        render 'designs/new'
      end
    end
  end

  def show
    @design = Design.find(params[:id])
  end

  private

  def design_params
    params.require(:design).permit(:name, :style, :fashion, :designer_id, :fashion_show_id)
  end

  def set_fashion_show
    @fashion_show = FashionShow.find_by(id: params[:fashion_show_id])
  end

  def set_designer
    @designer = User.find_by(id: params[:designer_id])
  end



end
