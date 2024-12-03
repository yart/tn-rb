# frozen_string_literal: true

describe CUI::Input do
  describe '.new' do
    it 'creates a Text object when type is text' do
      settings = { type: :text }
      expect(CUI::Input::Text).to receive(:new).with(hash_including(settings))
      CUI::Input.new(**settings)
    end

    it 'creates a Number object when type is number' do
      settings = { type: :number }
      expect(CUI::Input::Number).to receive(:new).with(hash_including(settings))
      CUI::Input.new(**settings)
    end

    it 'creates a BulkText object when type is text and list is true' do
      settings = { type: :text, list: true }
      expect(CUI::Input::BulkText).to receive(:new).with(hash_including(settings))
      CUI::Input.new(**settings)
    end

    it 'creates a BulkNumber object when type is number and list is true' do
      settings = { type: :number, list: true }
      expect(CUI::Input::BulkNumber).to receive(:new).with(hash_including(settings))
      CUI::Input.new(**settings)
    end

    it 'defaults to Text object when no type is specified' do
      settings = {}
      expect(CUI::Input::Text).to receive(:new).with(hash_including(settings))
      CUI::Input.new(**settings)
    end

    it 'passes label and limit keys derived from text and max_items' do
      settings = { text: 'Enter value', max_items: 5 }
      expected_settings = { label: 'Enter value', limit: 5 }
      expect(CUI::Input::Text).to receive(:new).with(hash_including(expected_settings))
      CUI::Input.new(**settings)
    end
  end
end
