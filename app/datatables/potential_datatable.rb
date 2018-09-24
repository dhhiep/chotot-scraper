class PotentialDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include PotentialsHelper
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def view_columns
    @view_columns ||= {
      id: { source: 'Potential.id', cond: :eq },
      name: { source: 'Potential.name' },
      phone: { source: 'Potential.phone' },
      remind_at: { source: 'Potential.remind_at' },
      source: { source: '' },
      actions: { source: '' }
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        id: record.id,
        name: record.name,
        phone: record.phone,
        remind_at: record.remind_at.try(:to_datepicker_format),
        source: potential_status_badge(record),
        actions: build_actions(record)
      }
    end
  end

  private

  def build_actions(record)
    [
      helper.link_to('EDIT', edit_potential_path(record), class: 'act btn btn-sm btn-success', method: :get),
      helper.link_to('DELETE', potential_path(record), class: 'act btn btn-sm btn-warning', method: :delete, remote: true, data: { original_title: "Delete", confirm: 'Bạn có muốn xóa số phone này không?' })
    ].join(' ').html_safe
  end

  def status(record)
  end

  def get_raw_records
    Potential.all
  end
end
