class AccountDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include AccountsHelper
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  # either define them one-by-one
  def_delegator :@view, :check_box_tag
  def_delegator :@view, :link_to
  def_delegator :@view, :mail_to
  def_delegator :@view, :edit_user_path

  def view_columns
    @view_columns ||= {
      id: { source: 'Account.id', cond: :eq },
      full_name: { source: 'Account.full_name' },
      phone: { source: 'Account.phone' },
      address: { source: 'Account.address', searchable: true, orderable: false },
      status: { source: 'Account.status', searchable: false },
      category: { source: '', searchable: false, orderable: false },
      action_edit: { source: '', searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        id: record.id,
        full_name: record.full_name,
        phone: phone_with_copy_to_clipboard(record.id, record.phone).html_safe,
        address: record.address_filtered,
        status: account_combine_status(record),
        category: record.category_names.join(', '),
        action_edit: action_edit(record).html_safe
      }
    end
  end

  private

  def get_raw_records
    @query = Account.active
    if options[:type].presence == :completed
      @query = @query.where('responses.completed_at IS NOT NULL')
    end
    @query
  end

  def phone_with_copy_to_clipboard(id, phone)
    <<-HTML
      <div style="width: 115px;">
        <a href="javascript:;" onclick="copyToClipboard(this, #{id}, '#{phone}')" style="margin-right: 5px;">
          <i class='fa fa-copy'></i>
        </a>
        #{phone}
      </div>
    HTML
  end

  def action_edit(record)
    actions = []
    actions << helper.link_to('VAL', mark_wse_status_account_path(record.id, status: :valid), class: 'act btn btn-sm btn-success', method: :post, remote: true)
    actions << helper.link_to('DUP', mark_wse_status_account_path(record.id, status: :duplicate), class: 'act btn btn-sm btn-warning', method: :post, remote: true)
    actions << helper.link_to('INV', mark_wse_status_account_path(record.id, status: :invalid), class: 'act btn btn-sm btn-danger', method: :post, remote: true)
    special_actions = []
    special_actions << helper.link_to('DEL', hide_account_path(record.id), class: 'btn btn-sm btn-secondary', method: :post, remote: true, data: { original_title: "Delete", confirm: 'Bạn có muốn xóa số phone này không?' })

    <<-HTML
      <div style="width: 195px;">
        #{[actions.join(''), special_actions.join('&nbsp;')].join(' | ')}
      </div>
    HTML
  end

  def count_responses(record)
    # if survey = Survey.find_by_qt_survey_id(ENV['MAIN_SURVEY_ID'])
    #   responses = survey.responses.where(account_id: record.id).sort_by_end_date.first
    #   responses.answers.empty.count
    # else
    # end
    0
  end
end
