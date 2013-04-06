class EmailValidator < ActiveModel::EachValidator
  RE_VALID_EMAIL = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  def validate_each(record, attribute, value)
    unless value =~ RE_VALID_EMAIL
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.messages.invalid_email', default: 'is not an email'))
    end
  end
end
