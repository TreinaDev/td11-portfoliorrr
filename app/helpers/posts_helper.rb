module PostsHelper
  def date_fixer(post)
    if post.draft?
      'Criado em: '
    elsif post.scheduled?
      'Agendado para: '
    else
      'Publicado em: '
    end
  end

  def content_fixer(post)
    post.content.to_plain_text.truncate(300, separator: ' ').gsub(/\[[^\]]+\.\w+\]/, '')
  end
end
