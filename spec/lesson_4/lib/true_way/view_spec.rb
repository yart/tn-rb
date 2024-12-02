# frozen_string_literal: true

describe Lesson4::TrueWay::View do
  let(:template_path) { 'template.erb' }
  let(:context_binding) { binding }
  let(:view) { described_class.new(context_binding) }

  before do
    File.write(template_path, <<~ERB)
      Title: <%= @title %>
      Content: <%= @content %>
    ERB

    @title = 'Hello, World!'
    @content = 'This is an example content.'
  end

  after do
    File.delete(template_path) if File.exist?(template_path)
  end

  it 'renders the template with the provided context' do
    rendered_content = view.render(template_path)

    expect(rendered_content).to include('Title: Hello, World!')
    expect(rendered_content).to include('Content: This is an example content.')
  end
end
