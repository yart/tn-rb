# frozen_string_literal: true

describe CUI::Input::Number do
  describe '.receive' do
    subject(:positives) { described_class.new }
    subject(:negatives) { described_class.new(allow_negatives: true) }

    before do
      # Supprising any output
      [$stdout, positives, negatives].each { |object| allow(object).to receive(:print) }
    end

    it 'returns the user input converted to Integer' do
      allow(positives).to receive(:gets).and_return('15')

      expect(positives.receive).to eq 15
    end

    it 'returns the user input converted to Integer even when user puts letters with numbers' do
      allow(positives).to receive(:gets).and_return('1-ss??5a!!--ll')

      expect(positives.receive).to eq 1
    end

    it 'returns the user input converted to a negative Integer when user puts a negative value' do
      allow(negatives).to receive(:gets).and_return('-1')

      expect(negatives.receive).to eq(-1)
    end
  end
end
