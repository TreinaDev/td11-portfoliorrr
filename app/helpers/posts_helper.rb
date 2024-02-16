module PostsHelper
  def date_fixer(post)
    if post.draft?
      t('posts.helpers.created_at')
    elsif post.scheduled?
      t('posts.helpers.scheduled_for')
    else
      t('posts.helpers.published_at')
    end
  end

  def content_fixer(post)
    post.content.to_plain_text.truncate(300, separator: ' ').gsub(/\[[^\]]+\.\w+\]/, '')
  end

  def get_tags(amount)
    tags = []
    Post.last(amount).each do |post|
      tags.concat(post.tag_list)
    end
    tags.last(11).uniq
  end
end
