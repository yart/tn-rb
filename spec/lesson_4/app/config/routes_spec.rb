# frozen_string_literal: true

describe Lesson4::App::Config::Routes do
  describe '.draw' do
    before { described_class.clear }

    it 'allows registering routes using a DSL block' do
      mock_controller = double('DashboardsController', execute: nil)
      described_class.draw do
        menu :dashboards, to: mock_controller
      end

      expect(described_class.routes[:dashboards]).to eq mock_controller
    end
  end

  describe '.method_missing' do
    before { allow(Lesson4::App::Controller).to receive(:const_get).and_call_original }

    it 'dynamically resolves controller shortcuts' do
      allow(Lesson4::App::Controller).to receive(:const_get).with('DashboardsController').and_return(double)
      expect(described_class.dashboards_controller).to be_a(Object)
    end

    it 'raises an error for unresolved shortcuts' do
      expect { described_class.undefined_controller }
        .to raise_error(NameError, /undefined method `undefined_controller`/)
    end
  end

  describe '.respond_to_missing?' do
    it 'returns true for valid controller shortcuts' do
      allow(Lesson4::App::Controller).to receive(:const_defined?).with('DashboardsController').and_return(true)
      expect(described_class.respond_to?(:dashboards_controller)).to be true
    end

    it 'returns false for invalid methods' do
      expect(described_class.respond_to?(:undefined_controller)).to be false
    end
  end
end
