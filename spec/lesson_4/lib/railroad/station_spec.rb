# frozen_string_literal: true

describe Lesson4::Railroad::Station do
  subject(:station) { described_class.new('Test Station') }

  let(:cargo_wagon_class) { Class.new }
  let(:passenger_wagon_class) { Class.new }
  let(:cargo_train) { instance_double('StubbedTrain', wagon_type: cargo_wagon_class) }
  let(:passenger_train) { instance_double('StubbedTrain', wagon_type: passenger_wagon_class) }

  context 'when created' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:trains).with(0..1).arguments }
    it { is_expected.to respond_to(:handle).with(1).argument }
    it { is_expected.to respond_to(:send).with(1).argument }

    it 'has the correct name' do
      expect(station.name).to eq('Test Station')
    end
  end

  context 'when handling trains' do
    it 'adds trains to the station and lists all trains' do
      station.handle(cargo_train)
      expect(station.trains).to eq [cargo_train]

      station.handle(passenger_train)
      expect(station.trains).to eq [cargo_train, passenger_train]
    end

    it 'filters trains by wagon type' do
      station.handle(cargo_train)
      station.handle(passenger_train)

      expect(station.trains(cargo_wagon_class)).to eq [cargo_train]
      expect(station.trains(passenger_wagon_class)).to eq [passenger_train]
    end

    it 'removes trains from the station' do
      station.handle(cargo_train)
      station.handle(passenger_train)

      station.send(cargo_train)
      expect(station.trains).to eq [passenger_train]
    end
  end
end
