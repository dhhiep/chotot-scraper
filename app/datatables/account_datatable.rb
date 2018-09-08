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
      full_name: { source: 'Account.full_name', searchable: false, orderable: false },
      phone: { source: 'Account.phone' },
      address: { source: 'Account.address', searchable: true, orderable: false },
      status: { source: 'Account.status', searchable: false },
      area_name: { source: 'Account.area_name', searchable: false, orderable: true },
      category: { source: 'Account.category_names', searchable: false, orderable: false },
      action_edit: { source: '', searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        id: record.id,
        full_name: record.full_name,
        phone: phone_with_copy_to_clipboard(record, record.phone).html_safe,
        address: record.address_filtered,
        status: account_combine_status(record),
        area_name: record.area_name,
        # category: record.category_names,
        action_edit: account_actions_edit(record).html_safe
      }
    end
  end

  private

  def get_raw_records
    @query = Account.active
    if params[:type].presence == 'favorites'
      @query = @query.favorites
    end
    @query
  end

  def phone_with_copy_to_clipboard(record, phone)
    <<-HTML
      <div style="width: 130px;">
        <div class="phone">
          <a href="javascript:;" data-id="#{record}" data-clipboard-text="#{phone}" class='copy-account-phone' style="margin-right: 5px;">
            <i class='fa fa-copy'></i>
          </a>
          #{phone}
        </div>
        <div class="phone_actions">
          #{account_wse_actions_edit(record)[1..2].join('').html_safe}
        </div>
      </div>
    HTML
  end
end
