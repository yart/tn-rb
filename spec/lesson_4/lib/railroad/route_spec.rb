# frozen_string_literal: true

class DummyStation
  attr_reader :name

  def initialize(name) = @name = name
end

describe Lesson4::Railroad::Route do
  let(:first_station) { DummyStation.new('First') }
  let(:last_station) { DummyStation.new('Last') }
  let(:route) { described_class.new(first_station, last_station) }

  describe '.new' do
    context 'when no stations are provided' do
      it 'raises a StationsNumberError' do
        expect { described_class.new }.to raise_error(Lesson4::Railroad::Route::StationsNumberError, /No stations/)
      end
    end

    context 'when only one station is provided' do
      it 'raises a StationsNumberError' do
        expect { described_class.new(first_station) }.to raise_error(Lesson4::Railroad::Route::StationsNumberError, /Only one station/)
      end
    end

    context 'when more than two stations are provided' do
      it 'raises a StationsNumberError' do
        extra_station = DummyStation.new('Extra')
        expect { described_class.new(first_station, last_station, extra_station) }
          .to raise_error(Lesson4::Railroad::Route::StationsNumberError, /3 stations given/)
      end
    end
  end

  describe '#list' do
    it 'returns the list of station names' do
      expect(route.list).to eq %w[First Last]
    end
  end

  describe '#add' do
    let(:intermediate_station) { DummyStation.new('Intermediate') }

    it 'adds an intermediate station to the route' do
      route.add(intermediate_station)
      expect(route.list).to eq %w[First Intermediate Last]
    end
  end

  describe '#remove' do
    let(:intermediate_station) { DummyStation.new('Intermediate') }

    before { route.add(intermediate_station) }

    context 'when removing an intermediate station' do
      it 'removes the station from the route' do
        route.remove(intermediate_station)
        expect(route.list).to eq %w[First Last]
      end
    end

    context 'when trying to remove the first station' do
      it 'does not remove the station' do
        route.remove(first_station)
        expect(route.list).to eq %w[First Intermediate Last]
      end
    end

    context 'when trying to remove the last station' do
      it 'does not remove the station' do
        route.remove(last_station)
        expect(route.list).to eq %w[First Intermediate Last]
      end
    end
  end
end
