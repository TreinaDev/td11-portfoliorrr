module PostHelper
  def time_since(time)
    seconds = Time.current - time
    minutes = (seconds / 60).to_i
    hours = (minutes / 60).to_i
    days = (hours / 24).to_i

    return "#{seconds.to_i} s" if seconds < 60
    return "#{minutes} m" if minutes < 60
    return "#{hours} h" if hours < 24

    "#{days} d"
  end
end
