class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attachment, message: 'You must be author to delete attachment'
    @attachment.purge
  end
end
