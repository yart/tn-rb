# frozen_string_literal: true

describe Lesson4::TrueWay::Router::ControllerFactory do
  let(:factory) { described_class }

  before do
    stub_const('MainMenuController', Class.new)
  end

  describe '.get_controller' do
    it 'returns the correct controller class' do
      expect(factory.get_controller('main_menu')).to eq(MainMenuController)
    end

    it 'raises ControllerNotFoundError if the controller class is not found' do
      expect { factory.get_controller('unknown') }.to raise_error(Lesson4::TrueWay::Router::Error::ControllerNotFoundError, /Controller not found/)
    end
  end
end
