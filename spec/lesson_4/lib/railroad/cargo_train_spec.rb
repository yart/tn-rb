# frozen_string_literal: true

describe Lesson4::Railroad::CargoTrain do
  let!(:cargo) { described_class.new(number: 'test') }

  let(:wagon) { Lesson4::Railroad::CargoWagon.new } # TODO: looks like we need to remove this dependency.

  context 'when cargo train created' do
    it { expect(described_class).to be < Lesson4::Railroad::Train }
    it { expect(cargo.number).to eq 'test' }
  end

  context 'when attaching wagons' do
    before do
      cargo.stop
      5.times { cargo.attach(wagon) }
    end

    it { expect(cargo.speed).to eq 0 }
    it { expect(cargo.wagons.count).to eq 5 }
  end
end
