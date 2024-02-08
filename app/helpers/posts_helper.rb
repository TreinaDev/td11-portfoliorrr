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
end
