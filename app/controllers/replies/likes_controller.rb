module Replies
  class LikesController < LikesController
    before_action :set_likeable

    private

    def set_likeable
      @likeable = Reply.find(params[:reply_id])
      @post = @likeable.comment.post
    end
  end
end
