# frozen_string_literal: true

describe Lesson4::App do
  describe '.l10n' do
    context 'when the localization path is configured' do
      before do
        Lesson4::App::Config.l10n_path = '/path/to/l10n.yml'
        allow(YAML).to receive(:load_file)
          .and_return({ key: 'value' })
      end

      it 'loads and returns the localization data as a hash' do
        expect(described_class.l10n).to eq({ key: 'value' })
      end
    end

    context 'when the localization path is not configured' do
      before { Lesson4::App::Config.l10n_path = nil }

      it 'raises a ConfigurationError' do
        expect { described_class.l10n }.to raise_error(Lesson4::App::Config::ConfigurationError, /l10n_path/)
      end
    end
  end

  describe '.db_adapter' do
    context 'when the database adapter is configured' do
      before { Lesson4::App::Config.db_adapter = :adapter }

      it 'returns the configured database adapter' do
        expect(described_class.db_adapter).to eq :adapter
      end
    end

    context 'when the database adapter is not configured' do
      before { Lesson4::App::Config.db_adapter = nil }

      it 'raises a ConfigurationError' do
        expect { described_class.db_adapter }.to raise_error(Lesson4::App::Config::ConfigurationError, /db_adapter/)
      end
    end
  end

  describe '.dir' do
    it 'returns the directory path of the application' do
      expect(described_class.dir).to eq File.expand_path('../../lesson_4', __dir__)
    end
  end
end
