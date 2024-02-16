module Posts
  class LikesController < LikesController
    before_action :set_likeable

    private

    def set_likeable
      @likeable = Post.friendly.find(params[:post_id])
      @post = @likeable
    end
  end
end
