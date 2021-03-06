# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  describe 'GET /' do
    it 'returns the page as expected' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
