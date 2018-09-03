module ApplicationHelper
  def menu_items
    items = [
      { name: 'Accounts', path: accounts_path },
      { name: 'Lists', path: lists_path },
      { name: 'Categories', path: categories_path },
      { name: 'Logs', path: logs_path }
    ]

    items.map do |item|
      <<-HTML
        <li class="nav-item #{request.path == item[:path] ? 'active' : ''}">
          <a href="#{item[:path]}" class='nav-link'>#{item[:name]}</a>
        </li>
      HTML
    end.join('').html_safe
  end
end
