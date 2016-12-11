module ApplicationHelper
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def plural_form(count, a, b, c)
    return a if (count == 1)
    return b if (count < 5)
    return c
  end

  def format_date(date)
    date.strftime '%-d.%-m.%Y %H:%M'
  end

  def election_scope_name(election)
    case election.scope_type
      when 'general' then
        "Celorepublikové"
      when 'region' then
        "Krajské / #{Region.find(election.scope_id_region).name}"
    end
  end

end
