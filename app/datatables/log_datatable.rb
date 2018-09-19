class LogDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def view_columns
    @view_columns ||= {
      uuid: { source: 'Summary.uuid', cond: :eq },
      description: { source: 'Summary.description' }
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        uuid: log_details(record).html_safe,
        description: record.description
      }
    end
  end

  private

  def log_details(record)
    <<-HTML
      <a href="/logs/#{record.uuid}">#{record.uuid}</a>
    HTML
  end

  def get_raw_records
    Summary.order(id: :desc)
  end
end
