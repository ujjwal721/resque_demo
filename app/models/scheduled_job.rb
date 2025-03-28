class ScheduledJob < ApplicationRecord
    scope :active, -> { where(soft_delete: 0) }
    def parsed_parameters
        parameters.present? ? JSON.parse(parameters) : []
      rescue JSON::ParserError
        []
      end
end
