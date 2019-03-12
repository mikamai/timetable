# == Schema Information
#
# Table name: report_entries_exports
#
#  id              :uuid             not null, primary key
#  completed_at    :datetime
#  export_query    :json
#  file            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null
#  user_id         :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe ReportEntriesExport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
