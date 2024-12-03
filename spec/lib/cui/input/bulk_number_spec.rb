# frozen_string_literal: true

describe CUI::Input::BulkNumber do
  let(:prompt_label) { 'Enter numbers' }
  let(:prompt_string) { '> ' }
  let(:settings) { { label: prompt_label, prompt: prompt_string } }

  before do
    # Мокируем методы ввода и вывода
    allow_any_instance_of(CUI::Input::Text).to receive(:print)
    allow_any_instance_of(CUI::Input::Text).to receive(:clear_lines)
    allow_any_instance_of(CUI::Input::Text).to receive(:clear_line)
  end

  describe '#receive' do
    context 'when limit is not set' do
      let(:bulk_number) { described_class.new(**settings) }

      it 'collects multiple numeric inputs until an empty line is entered' do
        inputs = ['123', '456', '789', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'splits input containing separator into multiple numbers' do
        inputs = ['123, 456, 789', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'filters out non-numeric input' do
        inputs = ['123abc, 456def', '789ghi', '', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'handles combination of single and multiple numeric inputs' do
        inputs = ['123', '456, 789', '100', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789, 100])
      end

      it 'returns empty array when user immediately enters empty input' do
        inputs = ['']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([])
      end
    end

    context 'when limit is set' do
      let(:limit) { 3 }
      let(:bulk_number) { described_class.new(**settings.merge(limit: limit)) }

      it 'collects numeric inputs up to the limit, skipping empty inputs' do
        inputs = ['123', '', '456', '', '789', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'does not count empty inputs towards the limit' do
        inputs = ['', '', '123', '', '456', '789', '', '100']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'stops collecting when limit is reached with inputs containing separators' do
        inputs = ['123, 456', '789, 100', '200']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end
    end

    context 'with custom separator' do
      let(:separator) { ';' }
      let(:bulk_number) { described_class.new(**settings.merge(separator: separator)) }

      it 'uses custom separator to split inputs' do
        inputs = ['123; 456; 789', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end

      it 'handles inputs without separator as single numbers' do
        inputs = ['123', '456; 789', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789])
      end
    end

    context 'when allow_negatives is true' do
      let(:bulk_number) { described_class.new(**settings.merge(allow_negatives: true)) }

      it 'accepts negative numbers' do
        inputs = ['-123', '-456, 789', '-100, -200', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([-123, -456, 789, -100, -200])
      end

      it 'filters out non-numeric input with negative numbers allowed' do
        inputs = ['abc', '-123abc', '456def', '', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([-123, 456])
      end
    end

    context 'when allow_negatives is false' do
      let(:bulk_number) { described_class.new(**settings.merge(allow_negatives: false)) }

      it 'ignores negative signs and collects positive numbers only' do
        inputs = ['-123', '456, -789', '-100, 200', '']
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456, 789, 100, 200])
      end
    end

    context 'when input is nil (EOF)' do
      let(:bulk_number) { described_class.new(**settings) }

      it 'returns collected numbers before EOF' do
        inputs = ['123', '456', nil]
        allow(bulk_number).to receive(:gets).and_return(*inputs)

        result = bulk_number.receive
        expect(result).to eq([123, 456])
      end
    end
  end
end
