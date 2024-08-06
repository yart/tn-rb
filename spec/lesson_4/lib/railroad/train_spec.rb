# frozen_string_literal: true

class DummyStation
  attr_reader :name

  def initialize(name) = @name = name
end

class DummyRoute
  attr_reader :list

  def initialize(list) = @list = list
end

describe Lesson4::Railroad::Train do
  let!(:train) { described_class.new(number: 'test') }

  let(:wagon) { Lesson4::Railroad::Wagon.new } # TODO: looks like we need to remove this dependency.
  let(:stations) do
    [
      DummyStation.new('first'),
      DummyStation.new('other'),
      DummyStation.new('another'),
      DummyStation.new('last')
    ]
  end
  let(:route) { DummyRoute.new(stations) }

  context 'when train created' do
    it { expect(train).to respond_to(:number) }
    it { expect(train).to respond_to(:wagons) }
    it { expect(train).to respond_to(:attach) }
    it { expect(train).to respond_to(:detach) }
    it { expect(train).to respond_to(:speed) }
    it { expect(train).to respond_to(:speed=).with(1).argument }
    it { expect(train).to respond_to(:stop) }
    it { expect(train).to respond_to(:route=).with(1).argument }
    it { expect(train).to respond_to(:location).with(0..1).arguments }
    it { expect(train).to respond_to(:backward) }
    it { expect(train).to respond_to(:forward) }

    it { expect(train.number).to eq 'test' }
    it { expect(train.speed).to eq 0 }
  end

  context 'when attaching wagons' do
    before do
      train.stop
      5.times { train.attach(wagon) }
    end

    it { expect(train.speed).to eq 0 }
    it { expect(train.wagons.count).to eq 5 }
  end

  context 'when detaching wagons' do
    before do
      train.stop
      5.times { train.attach(wagon) }
      train.detach
    end

    it { expect(train.speed).to eq 0 }
    it { expect(train.wagons.count).to eq 4 }
  end

  context 'when a route given' do
    before { train.route = route }

    it { expect(train.location(:current)).to eq stations.first }
  end

  context 'when moving along the route' do
    before { train.route = route }

    context 'when moving forward' do
      before { train.forward }

      it { expect(train.speed).not_to eq 0 }
      it { expect(train.location(:current)).to eq stations[1] }
      it { expect(train.location(:previous)).to eq stations[0] }
      it { expect(train.location(:next)).to eq stations[2] }
    end

    context 'when current station is the last one, it can not move forward' do
      before { 4.times { train.forward } }

      it { expect(train.location(:current)).to eq stations[3] }
      it { expect(train.location(:next)).to be_nil }
    end

    context 'when moving backward' do
      before do
        3.times { train.forward }
        2.times { train.backward }
      end

      it { expect(train.speed).not_to eq 0 }
      it { expect(train.location(:current)).to eq stations[1] }
      it { expect(train.location(:previous)).to eq stations[0] }
      it { expect(train.location(:next)).to eq stations[2] }
    end

    context 'when current station is the first one, it can not move backward' do
      before { train.backward }

      it { expect(train.location(:current)).to eq stations[0] }
      it { expect(train.location(:previous)).to be_nil }
    end
  end
end
