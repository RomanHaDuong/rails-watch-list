class ListsController < ApplicationController
  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
    @movies = Movie.all
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)

    if @list.save
      redirect_to list_path(@list), notice: "List was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @list = List.find(params[:id])
    if @list.destroy
      redirect_to lists_path, notice: "List was successfully deleted."
    else
      redirect_to lists_path, alert: "There was an issue deleting the list."
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :photo)
  end
end
