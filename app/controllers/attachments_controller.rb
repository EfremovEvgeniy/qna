class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attachment
    @attachment.purge
  end
end
