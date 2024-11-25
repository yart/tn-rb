# frozen_string_literal: true

describe Lesson4::App do
  describe '.l10n' do
    context 'when the localization file is valid' do
      before do
        allow(YAML).to receive(:load_file)
          .and_return({ key: 'value' })
      end

      it 'loads and returns the localization data as a hash' do
        expect(described_class.l10n).to eq({ key: 'value' })
      end
    end

    context 'when the localization file is missing' do
      before do
        allow(YAML).to receive(:load_file)
          .and_raise(Errno::ENOENT)
      end

      it 'raises a LocalizationError' do
        expect { described_class.l10n }.to raise_error(Lesson4::App::LocalizationError, /Localization file error/)
      end
    end

    context 'when the localization file has syntax errors' do
      before do
        allow(YAML).to receive(:load_file)
          .and_raise(Psych::SyntaxError.new('file', 0, 0, 0, 'bad syntax', 'file'))
      end

      it 'raises a LocalizationError' do
        expect { described_class.l10n }.to raise_error(Lesson4::App::LocalizationError, /Localization file error/)
      end
    end
  end

  describe '.dir' do
    it 'returns the directory path of the application' do
      expect(described_class.dir).to eq File.expand_path('../../lesson_4', __dir__)
    end
  end

  describe '.db_adapter' do
    it 'returns an instance of DatabaseAdapter::SimpleDB' do
      expect(described_class.db_adapter).to be_an_instance_of(DatabaseAdapter::SimpleDB)
    end

    it 'initializes the adapter with the correct path' do
      expect(described_class.db_adapter.instance_variable_get(:@db_path))
        .to eq "#{described_class.dir}/db/simple_db"
    end
  end
end
