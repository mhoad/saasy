# frozen_string_literal: true

# Inspect the incoming requests to see if they match the
# specified criteria (i.e. if a subdomain is present)
class SubdomainRequired
  def self.matches?(request)
    request.subdomain.present? && request.subdomain != 'www'
  end
end
