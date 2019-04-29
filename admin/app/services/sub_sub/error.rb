# frozen_string_literal: true

class SubSub
  class Error
    def initialize(error_hash)
      @error_hash = error_hash
    end

    def populate_model(model)
      @error_hash.each do |attribute, messages|
        messages.each do |message|
          model.errors.add(attribute, message)
        end
      end
    end
  end
end
