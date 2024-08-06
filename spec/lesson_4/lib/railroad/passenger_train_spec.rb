# frozen_string_literal: true

describe Lesson4::Railroad::PassengerTrain do
  let!(:passenger) { described_class.new(number: 'test') }

  let(:wagon) { Lesson4::Railroad::PassengerWagon.new } # TODO: looks like we need to remove this dependency.

  context 'when passenger train created' do
    it { expect(described_class).to be < Lesson4::Railroad::Train }
    it { expect(passenger.number).to eq 'test' }
  end

  context 'when attaching wagons' do
    before do
      passenger.stop
      5.times { passenger.attach(wagon) }
    end

    it { expect(passenger.speed).to eq 0 }
    it { expect(passenger.wagons.count).to eq 5 }
  end
end
