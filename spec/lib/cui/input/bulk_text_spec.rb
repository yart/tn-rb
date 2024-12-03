# frozen_string_literal: true

describe CUI::Input::BulkText do
  let(:prompt_label) { 'Enter items' }
  let(:prompt_string) { '> ' }
  let(:settings) { { label: prompt_label, prompt: prompt_string } }

  describe '#receive' do
    context 'when limit is not set' do
      it 'collects multiple inputs until an empty line is entered' do
        inputs = ['apple', 'banana', 'cherry', '']
        bulk_text = described_class.new(**settings)
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end

      it 'splits input containing separator into multiple items' do
        inputs = ['apple, banana, cherry', '']
        bulk_text = described_class.new(**settings)
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end

      it 'handles combination of single inputs and inputs with separators' do
        inputs = ['apple', 'banana, cherry', 'date', '']
        bulk_text = described_class.new(**settings)
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry date])
      end

      it 'returns empty array when user immediately enters empty input' do
        inputs = ['']
        bulk_text = described_class.new(**settings)
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq([])
      end
    end

    context 'when limit is set' do
      let(:limit) { 3 }
      let(:bulk_text) { described_class.new(**settings.merge(limit: limit)) }

      it 'collects non-empty inputs up to the limit, skipping empty inputs' do
        inputs = ['apple', '', 'banana', '', 'cherry', '']
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end

      it 'does not count empty inputs towards the limit' do
        inputs = ['', '', 'apple', '', 'banana', 'cherry', '', 'date']
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end

      it 'stops collecting when limit is reached with inputs containing separators' do
        inputs = ['apple, banana', 'cherry, date', 'elderberry']
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end
    end

    context 'with custom separator' do
      let(:separator) { ';' }
      let(:bulk_text) { described_class.new(**settings.merge(separator: separator)) }

      it 'uses custom separator to split inputs' do
        inputs = ['apple; banana; cherry', '']
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end

      it 'handles inputs without separator as single items' do
        inputs = ['apple', 'banana; cherry', '']
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana cherry])
      end
    end

    context 'when input is nil (EOF)' do
      it 'returns collected items before EOF' do
        inputs = ['apple', 'banana', nil]
        bulk_text = described_class.new(**settings)
        allow(bulk_text).to receive(:gets).and_return(*inputs)

        result = bulk_text.receive
        expect(result).to eq(%w[apple banana])
      end
    end
  end
end
