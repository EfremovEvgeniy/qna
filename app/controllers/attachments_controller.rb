class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  helper_method :attachment

  def destroy
    @attachment.purge if current_user.author_of?(attachment.record)
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
