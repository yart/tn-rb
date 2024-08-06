# frozen_string_literal: true

describe Lesson4::Railroad::PassengerWagon do
  context 'when passenger wagon created' do
    it { expect(described_class).to be < Lesson4::Railroad::Wagon }
  end
end
