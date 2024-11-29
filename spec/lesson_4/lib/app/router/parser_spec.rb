# frozen_string_literal: true

describe Lesson4::App::Router::Parser do
  let(:parser) { described_class }

  describe '.split_path_and_query' do
    it 'splits path and query correctly' do
      expect(parser.split_path_and_query('/stations/add?name=Central')).to eq(['/stations/add', 'name=Central'])
      expect(parser.split_path_and_query('/stations/list')).to eq(['/stations/list', ''])
    end
  end

  describe '.path_to_regex' do
    it 'converts a route with dynamic segments to regex' do
      expect(parser.path_to_regex('/stations/:id/edit')).to eq(%r{^/stations/\w+/edit$})
    end
  end

  describe '.extract_dynamic_params' do
    it 'extracts dynamic params from a route' do
      expect(parser.extract_dynamic_params('/stations/:id/edit', '/stations/42/edit')).to eq(id: '42')
    end
  end

  describe '.parse_query' do
    it 'parses query parameters into a hash' do
      expect(parser.parse_query('key=value&name=Central')).to eq({ key: 'value', name: 'Central' })
      expect(parser.parse_query('')).to eq({})
    end

    it 'handles invalid query strings gracefully' do
      expect(parser.parse_query('=value')).to eq({})
      expect(parser.parse_query('key=')).to eq({ 'key' => '' })
    end
  end
end
