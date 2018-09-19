module PotentialsHelper
  def potential_status_badge(potential)
    badge, txt =
      if potential.account_id.present?
        %w[warning Account]
      else
        %w[success Admin]
      end

    "<span class='badge badge-#{badge}'>#{txt}</span>".html_safe
  end
end
