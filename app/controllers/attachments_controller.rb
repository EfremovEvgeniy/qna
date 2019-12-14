class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attachment.record
    @attachment.purge
  end
end
