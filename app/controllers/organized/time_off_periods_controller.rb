# frozen_string_literal: true

module Organized
  class TimeOffPeriodsController < BaseController
    before_action :set_time_off_entry, only: :create

    def create
      @time_off_period = TimeOffPeriod.new create_params
      if @time_off_period.save
        array_of_business_dates.each &create_time_off_entries
        @time_off_entry = @time_off_period.time_off_entries.first
        respond_with current_organization, @time_off_entry,
                     location: -> { after_create_or_update_path @time_off_entry }
      else
        redirect_back fallback_location: new_organization_time_off_entry_path
      end
    end

    private

    def set_time_off_entry
      @time_off_entry = TimeOffEntry.new user: impersonating_or_current_user, executed_on: Date.current
    end

    def create_time_off_entries
      lambda do |date|
        entry = TimeOffEntry.new
        entry.user_id = current_user.id
        entry.organization_id = current_organization.id
        entry.executed_on = date
        entry.amount = 8
        entry.notes = @time_off_period.notes
        entry.typology = @time_off_period.typology
        entry.time_off_period_id = @time_off_period.id
        authorize entry
        entry.save
      end
    end

    def array_of_business_dates
      (@time_off_period.start_date..@time_off_period.end_date).to_a.reject &is_weekend
    end

    def is_weekend
      -> (date) { (date.wday % 7 == 0) || (date.wday % 7 == 6) }
    end

    def after_create_or_update_path time_off_entry
      options = {
        as: time_off_entry.user != current_user ? time_off_entry.user.id : nil
      }
      organization_time_view_path current_organization, time_off_entry.time_view, options
    end

    def create_params
      params.require(:time_off_period).permit(:user_id, :notes, :start_date, :end_date, :typology)
            .reverse_merge(user_id: current_user.id, organization_id: current_organization.id)
    end

    def impersonating_user
      return nil unless params[:as]
      @impersonating_user ||= current_organization.users.find params[:as]
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def impersonating_or_current_user
      impersonating_user || current_user
    end
  end
end
