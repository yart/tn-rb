# frozen_string_literal: true

class DummyTrain
  attr_reader :type

  def initialize(type:) = @type = type
end

describe Lesson3::Railroad::Station do
  subject(:station) { described_class.new('test') }

  let(:cargo)     { DummyTrain.new(type: Lesson3::Railroad::CARGO) }
  let(:passenger) { DummyTrain.new(type: Lesson3::Railroad::PASSENGER) }

  context 'when created' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:trains).with(0..1).arguments }
    it { is_expected.to respond_to(:handle).with(1).argument }
    it { is_expected.to respond_to(:send).with(1).argument }

    it { expect(station.name).to eq 'test' }
  end

  context 'when handling trains' do
    it 'handles trains one by one and shows all trains inside' do
      station.handle(cargo)
      expect(station.trains).to eq [cargo]

      station.handle(passenger)
      expect(station.trains).to eq [cargo, passenger]
    end

    it 'shows trains by type' do
      station.handle(cargo)
      station.handle(passenger)

      expect(station.trains(Lesson3::Railroad::CARGO)).to eq [cargo]
      expect(station.trains(Lesson3::Railroad::PASSENGER)).to eq [passenger]
    end

    it 'send trains' do
      station.handle(cargo)
      station.handle(passenger)

      station.send(cargo)
      expect(station.trains).to eq [passenger]
    end
  end
end
