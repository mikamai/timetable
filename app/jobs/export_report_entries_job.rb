# frozen_string_literal: true

class ExportReportEntriesJob < ApplicationJob
  queue_as :exports

  def perform report_entries_export
    report = create_report report_entries_export
    report_entries_export.file = report_to_file(report)
    report_entries_export.completed_at = Time.now
    report_entries_export.save!
  end

  private

  def report_to_file report
    report.stream.tap do |stream|
      stream.define_singleton_method(:original_filename) { 'report.xlsx' }
    end
  end

  def create_report report_entries_export
    RubyXL::Workbook.new.tap do |workbook|
      sheet = workbook.worksheets[0]
      sheet.sheet_name = 'Entries'
      add_row_to_sheet sheet, 0, %w[Date Client Project Task Person Hours Notes]
      report_entries_for(report_entries_export).each_with_index do |time_entry, i|
        add_row_to_sheet sheet, i + 1, time_entry_row(time_entry)
      end
    end
  end

  def time_entry_row time_entry
    [
      time_entry.executed_on, time_entry.client_name, time_entry.project_name, time_entry.task_name,
      time_entry.user_name, time_entry.hours, time_entry.notes
    ]
  end

  def report_entries_for report_entries_export
    # Note: ActiveRecord #find_each and #find_in_batches ignore scoped ordering
    # making impossible to use it.
    # For this reason we have to rely on a plain #each, and limit the query to
    # the first 10_000 rows (just because we don't want to degrade performances)
    entries = TimeEntry.in_organization report_entries_export.organization
    scoped = policy_scope report_entries_export.organization_membership, entries
    q = scoped.ransack(report_entries_export.export_query).tap do |q|
      q.sorts = 'executed_on asc' if q.sorts.empty?
      q.executed_on_gteq = 30.days.ago if q.executed_on_gteq.blank?
      q.executed_on_lteq = Date.today if q.executed_on_lteq.blank?
    end
    q.result.includes(:project, :client, :task, :user).limit 10_000
  end

  def policy_scope user, collection
    Organized::TimeEntryPolicy::Scope.new(user, collection).resolve
  end

  def add_row_to_sheet sheet, row, cells
    cells.each_with_index do |v, i|
      c = sheet.add_cell row, i
      if v.is_a? Date # Date column
        c.set_number_format 'dd-mm-yy'
      elsif i.is_a? Float # Hours column
        c.set_number_format '0.00'
      end
      c.change_contents v
    end
  end
end
