class PotentialDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include PotentialsHelper
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def view_columns
    @view_columns ||= {
      id: { source: 'Potential.id', cond: :eq, searchable: false, orderable: false },
      name: { source: 'Potential.name', searchable: true, orderable: true },
      phone: { source: 'Potential.phone', searchable: true, orderable: true },
      owner: { source: 'Potential.owner', searchable: false, orderable: true },
      remind_at: { source: 'Potential.remind_at', searchable: false, orderable: true },
      last_comment: { source: '', searchable: false, orderable: false },
      actions: { source: '', searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        id: record.id,
        name: record.name,
        phone: record.phone,
        owner: record.owner,
        remind_at: record.remind_at.try(:to_datepicker_format),
        last_comment: record.last_comment.try(:fulltext),
        actions: build_actions(record).html_safe
      }
    end
  end

  private

  def build_actions(record)
    buttons =
      [
        helper.link_to('EDIT', edit_potential_path(record), class: 'act btn btn-sm btn-success', method: :get),
        helper.link_to('DELETE', potential_path(record), class: 'act btn btn-sm btn-warning', method: :delete, remote: true, data: { original_title: "Delete", confirm: 'Bạn có muốn xóa số phone này không?' })
      ].join(' ')

    <<-HTML
      <div style="width: 130px;">
        #{buttons}
      </div>
    HTML
  end

  def get_raw_records
    order_default = params["order"]["0"]['column'] == 0 rescue false
    order_default ? Potential.sort_by_remind_date.includes(:comments) : Potential.all.includes(:comments)
  end
end
