module PersonalInfosHelper
  def info_fixer(value)
    if value.nil? || value.blank?
      'não informado'
    else
      value
    end
  end
end
