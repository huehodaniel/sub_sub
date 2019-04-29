# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Should be used with validate_uniqueness_of to populate the error object correctly
  def unique_save(*args, **kwargs)
    save(*args, **kwargs)
  rescue ActiveRecord::RecordNotFound
    validate
    false
  end

  # Should be used with validate_uniqueness_of to populate the error object correctly
  def unique_update(*args, **kwargs)
    update(*args, **kwargs)
  rescue ActiveRecord::RecordNotFound
    validate
    false
  end
end
