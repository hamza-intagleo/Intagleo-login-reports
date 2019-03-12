# == Schema Information
#
# Table name: login_files
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LoginFile < ApplicationRecord
end
