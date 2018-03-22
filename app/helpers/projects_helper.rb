# frozen_string_literal: true

module ProjectsHelper
  def project_progress project
    return unless project.budget?
    content_tag :div, class: 'progress' do
      if project.total_amount <= project.budget
        project_progress_in_budget project
      else
        project_progress_out_of_budget project
      end
    end
  end

  private

  def project_progress_in_budget project
    progress_bar :info, 100 * project.total_amount / project.budget
  end

  def project_progress_out_of_budget project
    progress_amount = 100 * project.budget / project.total_amount
    progress_bar(:info, progress_amount) + progress_bar(:danger, 100 - progress_amount)
  end

  def progress_bar style, amount
    content_tag :div, class: "progress-bar bg-#{style}", style: "width: #{amount}%" do
    end
  end
end
