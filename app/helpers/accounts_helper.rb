module AccountsHelper
  def account_status_badge(account)
    badge, txt =
      case account.status
      when 'status_new'
        %w[dark New]
      when 'status_inserted'
        %w[success Ins]
      end

    "<span id='status_#{account.id}' class='badge badge-#{badge}'>#{txt}</span>".html_safe
  end

  def account_wse_status(account)
    badge, txt =
      case account.wse_status
      when 'wse_unknown'
        %w[dark New]
      when 'wse_valid'
        %w[success Val]
      when 'wse_duplicate'
        %w[warning Dup]
      when 'wse_invalid'
        %w[danger Inv]
      end

    "<span id='wse_status_#{account.id}' class='badge badge-#{badge}'>#{txt}</span>".html_safe
  end

  def account_combine_status(account)
    "#{account_status_badge(account)} / #{account_wse_status(account)}".html_safe
  end

  def account_zalo_info(account)
    txt = 
      if zalo = account.zalo
        info =
          <<-HTML
            <div>
              <div>#{zalo.name}</div>
              <div>#{zalo.gender}</div>
              <div>#{zalo.birthday}</div>
            </div>
          HTML
        info.gsub("\n", '').gsub(' ', '')
      else
        helper.link_to('<i class="fa fa-download"></i>'.html_safe, fetch_zalo_info_account_path(account.id), class: 'act btn btn-sm btn-outline-primary', method: :post, remote: true)
      end

    "<div id='account_zalo_info_#{account.id}'>#{ txt }</div>".html_safe
  end

  def account_actions_edit(account)
    actions = []
    actions << helper.link_to('<i class="fa fa-star"></i>'.html_safe, toggle_favorite_account_path(account.id), class: "act btn btn-favorite btn btn-outline-primary #{account.favorite ? 'fv-active' : ''}", method: :post, remote: true)
    actions.concat(account_wse_actions_edit(account))

    special_actions = []
    special_actions << helper.link_to('DEL', hide_account_path(account.id), class: 'btn btn-sm btn-secondary', method: :post, remote: true, data: { original_title: "Delete", confirm: 'Bạn có muốn xóa số phone này không?' })

    <<-HTML
      <div class="actions" style="width: 240px;">
        #{[actions.join(''), special_actions.join('&nbsp;')].join(' | ')}
      </div>
    HTML
  end

  def account_wse_actions_edit(account)
    [
      helper.link_to('VAL', mark_wse_status_account_path(account.id, status: :valid), class: 'act btn btn-sm btn-success', method: :post, remote: true),
      helper.link_to('DUP', mark_wse_status_account_path(account.id, status: :duplicate), class: 'act btn btn-sm btn-warning', method: :post, remote: true),
      helper.link_to('INV', mark_wse_status_account_path(account.id, status: :invalid), class: 'act btn btn-sm btn-danger', method: :post, remote: true)
    ]
  end
end
