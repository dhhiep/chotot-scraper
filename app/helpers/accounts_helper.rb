module AccountsHelper
  def account_status_badge(account)
    badge, txt =
      case account.status
      when 'status_new'
        %w[dark NEW]
      when 'status_inserted'
        %w[success INS]
      end

    "<span id='status_#{account.id}' class='badge badge-#{badge}'>#{txt}</span>".html_safe
  end

  def account_wse_status(account)
    badge, txt =
      case account.wse_status
      when 'wse_unknown'
        %w[dark NEW]
      when 'wse_valid'
        %w[success VAL]
      when 'wse_duplicate'
        %w[warning DUP]
      when 'wse_invalid'
        %w[danger INV]
      end

    "<span id='wse_status_#{account.id}' class='badge badge-#{badge}'>#{txt}</span>".html_safe
  end

  def account_combine_status(account)
    "#{account_status_badge(account)} / #{account_wse_status(account)}".html_safe
  end
end
