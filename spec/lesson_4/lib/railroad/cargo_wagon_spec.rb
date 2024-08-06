# frozen_string_literal: true

describe Lesson4::Railroad::CargoWagon do
  context 'when cargo wagon created' do
    it { expect(described_class).to be < Lesson4::Railroad::Wagon }
  end
end
