require 'uri'
# Public: a GoogleContact.
# Should be initialized with a JSON "entry"
class GoogleContacts::Contact < GoogleContacts::Attribute

  DEFAULT_ATTRIBUTES = %w(title emails name deleted name organization
    phone_numbers structured_postal_addresses postal_address where content
    user_defined_fields birthday relation)

  # When an attribute isn't set, it won't be returned in the JSON at all.
  # These should return nil instead of raising NoMethodErrors
  DEFAULT_ATTRIBUTES.each do |attribute|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{attribute}                  # def title
        method_missing(:#{attribute})   #   method_missing(:title)
      rescue NoMethodError => e         # rescue NoMethodError => e
        nil                             #   nil
      end                               # end
    RUBY
  end

  def save
    save!
    # rescue some exceptions
  end

  def save!
    if exists?
      edit_endpoint = URI.parse(links.rel("edit").first.href).path
      GoogleContacts::Account.service.put(edit_endpoint, body: {entry: json})
    else
      new_endpoint = "/m8/feeds/contacts/default/full"
      GoogleContacts::Account.service.post(new_endpoint, body: {entry: json})
    end
  end

  def exists?
    # HEAD request
  end

  def name
    @entry.send(:name) rescue nil
  end

  def emails
    @entry.send(:emails) rescue nil
  end

  def relations
    @entry.send(:relations) rescue nil
  end

  def phone_numbers
    @entry.send(:phone_numbers) rescue nil
  end

  def user_defined_fields
    @entry.send(:user_defined_fields) rescue nil
  end

  def birthday
    @entry.send(:birthday) rescue nil
  end

  def structured_postal_addresses
    @entry.send(:structured_postal_addresses) rescue nil
  end

  def organization
    @entry.send(:organization) rescue nil
  end

  def job_title
    @entry.send(:job_title) rescue nil
  end

end
