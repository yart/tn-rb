# frozen_string_literal: true

describe Lesson4::TrueWay::Config do
  after do
    # Очистка состояния после каждого теста
    described_class.instance_variable_set(:@db_adapter, nil)
    described_class.instance_variable_set(:@l10n_path, nil)
    described_class.instance_variable_set(:@routes_path, nil)
  end

  describe '.db_adapter' do
    context 'when configured' do
      before { described_class.db_adapter = :adapter }

      it 'returns the configured database adapter' do
        expect(described_class.db_adapter).to eq :adapter
      end
    end

    context 'when not configured' do
      it 'raises a ConfigurationError' do
        expect { described_class.db_adapter }
          .to raise_error(Lesson4::TrueWay::Config::ConfigurationError, /db_adapter/)
      end
    end
  end

  describe '.l10n_path' do
    context 'when configured' do
      before { described_class.l10n_path = '/path/to/l10n.yml' }

      it 'returns the configured localization path' do
        expect(described_class.l10n_path).to eq '/path/to/l10n.yml'
      end
    end

    context 'when not configured' do
      it 'raises a ConfigurationError' do
        expect { described_class.l10n_path }
          .to raise_error(Lesson4::TrueWay::Config::ConfigurationError, /l10n_path/)
      end
    end
  end

  describe '.routes_path' do
    context 'when configured' do
      before { described_class.routes_path = '/path/to/routes.rb' }

      it 'returns the configured routes path' do
        expect(described_class.routes_path).to eq '/path/to/routes.rb'
      end
    end

    context 'when not configured' do
      it 'raises a ConfigurationError' do
        expect { described_class.routes_path }
          .to raise_error(Lesson4::TrueWay::Config::ConfigurationError, /routes_path/)
      end
    end
  end
end
