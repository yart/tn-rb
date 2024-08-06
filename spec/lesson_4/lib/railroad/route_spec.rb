# frozen_string_literal: true

class DummyStation
  attr_reader :name

  def initialize(name) = @name = name
end

describe Lesson4::Railroad::Route do
  let!(:route) { described_class.new(DummyStation.new('first'), DummyStation.new('last')) }

  context 'when no stations passed to a new route' do
    it { expect { described_class.new }.to raise_error(/No stations/) }
  end

  context 'when created has first and last stations' do
    it { expect(route).to respond_to(:list) }
    it { expect(route).to respond_to(:add).with(1).argument }
    it { expect(route).to respond_to(:remove).with(1).argument }

    describe '#list' do
      it { expect(route.list).to eq %w[first last] }
    end
  end

  context 'when add or remove stations' do
    let(:other) { DummyStation.new('other') }

    before { route.add(other) }

    describe '#add' do
      it { expect(route.list.count).to eq 3 }
      it { expect(route.list[1]).to eq 'other' }
    end

    describe '#remove' do
      before { route.remove(other) }

      it { expect(route.list.count).to eq 2 }
      it { expect(route.list.first).to eq 'first' }
      it { expect(route.list.last).to eq 'last' }
    end
  end
end
