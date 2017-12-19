# frozen_string_literal: true

module UserHelper
  def user_table_name user
    name = if user.confirmed?
      content_tag(:span) { user.name }
    elsif user.invitation_token
      content_tag(:span, class: 'badge badge-warning') { 'Awaiting invitation accept' }
    else
      content_tag(:span, class: 'badge badge-warning') { 'Awaiting confirmation' }
    end
    name + content_tag(:small, class: 'text-muted ml-2') { user.email }
  end
end
