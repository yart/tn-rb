# frozen_string_literal: true

class DummyStation
  attr_reader :name

  def initialize(name) = @name = name
end

class DummyRoute
  attr_reader :list

  def initialize(list: []) = @list = list
end

describe Railroad::Train do
  let!(:cargo)     { described_class.new(number: 'test_1', type: Railroad::CARGO, wagons: 10) }
  let!(:passenger) { described_class.new(number: 'test_2', type: Railroad::PASSENGER, wagons: 5) }

  let(:stations) do
    [
      DummyStation.new('first'),
      DummyStation.new('other'),
      DummyStation.new('another'),
      DummyStation.new('last')
    ]
  end
  let(:route) { DummyRoute.new(list: stations) }

  context 'when train created' do
    it { expect(cargo).to respond_to(:number) }
    it { expect(cargo).to respond_to(:type) }
    it { expect(cargo).to respond_to(:wagons) }
    it { expect(cargo).to respond_to(:attach) }
    it { expect(cargo).to respond_to(:detach) }
    it { expect(cargo).to respond_to(:speed) }
    it { expect(cargo).to respond_to(:speed=).with(1).argument }
    it { expect(cargo).to respond_to(:stop) }
    it { expect(cargo).to respond_to(:route=).with(1).argument }
    it { expect(cargo).to respond_to(:go).with(1).argument }
    it { expect(cargo).to respond_to(:location).with(0..1).arguments }

    it { expect(cargo.number).to eq 'test_1' }
    it { expect(cargo.type).to eq Railroad::CARGO }
    it { expect(cargo.wagons).to eq 10 }
    it { expect(cargo.speed).to eq 0 }
    it { expect(passenger.number).to eq 'test_2' }
    it { expect(passenger.type).to eq Railroad::PASSENGER }
    it { expect(passenger.wagons).to eq 5 }
    it { expect(passenger.speed).to eq 0 }
  end

  context 'when attaching/detaching wagons' do
    it { expect(cargo.speed).to eq 0 }
    it { expect(passenger.speed).to eq 0 }
  end

  context 'when attaching wagons' do
    before { cargo.attach }

    it { expect(cargo.wagons).to eq 11 }
  end

  context 'when detaching wagons' do
    before { passenger.detach }

    it { expect(passenger.wagons).to eq 4 }
  end

  context 'when a route given' do
    before { cargo.route = route }

    it { expect(cargo.current_station).to eq stations.first }
  end

  context 'when moving along the route' do
    before { passenger.route = route }

    context 'when moving forward' do
      before { passenger.go(Railroad::Train::FORWARD) }

      it { expect(passenger.speed).not_to eq 0 }
      it { expect(passenger.current_station).to eq stations[1] }
      it { expect(passenger.previous_station).to eq stations[0] }
      it { expect(passenger.next_station).to eq stations[2] }
    end

    context 'when current station is the last one, it can not move forward' do
      before { 4.times { passenger.go(Railroad::Train::FORWARD) } }

      it { expect(passenger.current_station).to eq station[3] }
      it { expect(passenger.next_station).to be_nil }
    end

    context 'when moving backward' do
      before do
        3.times { passenger.go(Railroad::Train::FORWARD) }
        2.times { passenger.go(Railroad::Train::BACKWARD) }
      end

      it { expect(passenger.current_station).to eq station[1] }
      it { expect(passenger.previous_station).to eq stations[0] }
      it { expect(passenger.next_station).to eq stations[2] }
    end

    context 'when current station is the first one, it can not move backward' do
      before { passenger.go(Railroad::Train::BACKWARD) }

      it { expect(passenger.current_station).to eq station[0] }
      it { expect(passenger.previous_station).to be_nil }
    end
  end
end
