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
      id: { source: 'Account.id', searchable: false, orderable: true },
      full_name: { source: 'Account.full_name', searchable: false, orderable: false },
      phone: { source: 'Account.phone', orderable: false },
      zalo_info: { source: '', searchable: false, orderable: false },
      updated_at: { source: 'Account.update_time', searchable: false, orderable: true },
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
        zalo_info: account_zalo_info(record),
        phone: phone_with_copy_to_clipboard(record, record.phone).html_safe,
        updated_at: account_datetime_info(record),
        address: record.address_filtered,
        status: account_combine_status(record),
        area_name: record.area_name,
        # category: record.category_names,
        action_edit: account_actions_edit(record).html_safe
      }
    end
  end

  private

  def account_datetime_info(record)
    [
      record.chotot_updated_at,
      record.chotot_created_at,
      record.created_at.to_display_date
    ].join("<br>").html_safe
  end

  def get_raw_records
    extra = params[:extra]
    account_status_filter = extra && extra[:account_status_filter].presence
    account_wse_status_filter = extra && extra[:account_wse_status_filter].presence
    account_area_filter = extra && extra[:account_area_filter].presence
    min_length = extra[:account_address_length_filter].to_i rescue 0

    @query = Account.active.only_hcm
    @query =
      case account_status_filter
      when 'new'
        @query.status_new
      when 'inserted'
        @query.status_inserted
      else
        @query
      end

    @query =
      case account_wse_status_filter
      when 'new'
        @query.wse_unknown
      when 'valid'
        @query.wse_valid
      when 'duplicate'
        @query.wse_duplicate
      when 'invalid'
        @query.wse_invalid
      else
        @query
      end

    @query = @query.address_min_length(min_length)
    @query = @query.in_district(account_area_filter) if Account.districts.include?(account_area_filter)
    @query = @query.favorites if params[:type].presence == 'favorites'
    @query
  end

  def phone_with_copy_to_clipboard(record, phone)
    <<-HTML
      <div style="width: 130px;">
        <div class="phone">
          <a href="javascript:;" data-id="#{record.id}" data-clipboard-text="#{phone}" class='copy-account-phone' style="margin-right: 5px;">
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
