module ApplicationHelper

  def edit_and_destroy_buttons(item)

    if user_is_admin?
      edit = link_to('Edit', url_for([:edit, item]), :class => "btn btn-primary")
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, :class => "btn btn-danger")
      raw("#{edit} #{del}")
    end
  end

  def round(item)
    item.round(1)
  end

end
