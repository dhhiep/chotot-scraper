class PotentialDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include PotentialsHelper
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
    ''
  end

  def status(record)
  end

  def get_raw_records
    Potential.all
  end
end
