class LogDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def view_columns
    @view_columns ||= {
      uuid: { source: 'Summary.uuid', cond: :eq },
      description: { source: 'Summary.description' },
      created_at: { source: 'Summary.created_at' }
    }
  end

  def data
    records.map do |record|
      {
        uuid: record.uuid,
        description: record.description,
        created_at: record.created_at.to_display_with_timezone
      }
    end
  end

  private

  def get_raw_records
    Summary.order(id: :desc)
  end
end
