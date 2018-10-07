class Summary < ApplicationRecord
  # default_scope {
  #   sql =
  #     <<-SQL
  #     select max(s.id) as id
  #     from summaries s
  #     GROUP BY uuid
  #     ORDER BY max(id) DESC
  #   SQL

  #   ActiveRecord::Base.connection.execute(sql)

  #   binding.pry
  #   find_by_sql(sql)
  # }
end

