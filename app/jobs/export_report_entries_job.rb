class ExportReportEntriesJob < ApplicationJob
  def perform report_entries_export
    report = create_report report_entries_export
    report_entries_export.file = report_to_file(report)
    report_entries_export.completed_at = Time.now
    report_entries_export.save!
  end

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
      report_entries_for(report_entries_export).find_each.with_index do |time_entry, i|
        add_row_to_sheet sheet, i + 1, [time_entry.executed_on, time_entry.client_name,
                                        time_entry.project_name, time_entry.task_name,
                                        time_entry.user_name, time_entry.amount,
                                        time_entry.notes]
      end
    end
  end

  def report_entries_for report_entries_export
    entries = TimeEntry.in_organization report_entries_export.organization
    scoped = policy_scope report_entries_export.organization_membership, entries
    q = scoped.ransack(report_entries_export.export_query).tap do |q|
      q.sorts = 'executed_on asc' if q.sorts.empty?
    end
    q.result.includes :project, :client, :task, :user
  end

  def policy_scope user, collection
    Organized::TimeEntryPolicy::Scope.new(user, collection).resolve
  end

  def add_row_to_sheet sheet, row, cells
    cells.each_with_index do |v, i|
      c = sheet.add_cell row, i
      c.set_number_format 'dd-mm-yy' if v.is_a? Date
      c.change_contents v
    end
  end
end
