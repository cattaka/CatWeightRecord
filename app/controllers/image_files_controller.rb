class ImageFilesController < ApplicationController
  before_action :set_image_file, only: [:show]

  def show
    unless @image_file&.data
      head 404
      return
    end

    send_data @image_file.data, :type => 'application/octet-stream',:disposition => 'inline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_file
      @image_file = ImageFile.find_by_id(params[:id])
    end
end
