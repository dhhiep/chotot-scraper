class AccountDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable
  include AccountsHelper

  def_delegator :@view, :check_box_tag
  def_delegator :@view, :link_to
  def_delegator :@view, :mail_to
  def_delegator :@view, :image_tag

  def view_columns
    @view_columns ||= {
      id: { source: "Account.id", cond: :eq },
      full_name: { source: "Account.full_name" },
      phone: { source: "Account.phone" },
      address: { source: "Account.address", :searchable => true, :orderable => false },
      status: { source: "Account.status", :searchable => false },
      category: { source: "", :searchable => false, :orderable => false },
      action_edit: { source: "", :searchable => false, :orderable => false }
    }
  end

  def data
    records.map do |record|
      {
        id: record.id,
        full_name: record.full_name,
        phone: phone_with_copy_to_clipboard(record.id, record.phone).html_safe,
        address: record.address_filtered,
        status: account_combine_status(record),
        category: record.category_names.join(', '),
        action_edit: action_edit(record)
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
      <a href="javascript:;" onclick="copyToClipboard(this, #{id}, '#{phone}')" style="margin-right: 5px;">
        <i class='fa fa-copy'></i>
      </a>
      #{phone}
    HTML
  end

  def action_edit(record)
    actions = []
    # actions << account_actions
    # actions << link_to("<span class='fa fa-info'></span>Details".html_safe, 'account_path(record)', class: "btn btn-primary btn-sm")
    # actions << link_to("<span class='fa fa-file-text-o'></span>Print PDF".html_safe, generate_pdf_account_path(record), :method => :post, class: "btn btn-success btn-sm") if record.completed?
    actions.join('').html_safe
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
