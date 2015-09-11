class AnyFieldValidator < ActiveModel::Validator
  def validate record
    if options[:fields]
      unless options[:fields].any? { |field| !record.send(field).blank? }
          record.errors[:base] << "At least one of the following attributes should be set: #{options[:fields].join(", ") }"
      end
    end
  end
end