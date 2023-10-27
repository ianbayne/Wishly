# frozen_string_literal: true

# REF: https://github.com/rails/rails/pull/29180
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
