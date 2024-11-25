# frozen_string_literal: true

describe Lesson4::App::Controller::BaseController do
  subject(:controller) { described_class.new(view) }

  let(:view) { instance_double('DummyView', render: nil) }

  describe '.new' do
    it 'accepts a view instance during initialization' do
      expect(controller.view).to eq view
    end
  end

  describe '#execute' do
    it 'raises NotImplementedError if not overridden' do
      expect { controller.execute }.to raise_error(NotImplementedError, 'Subclasses must implement the #execute method')
    end
  end
end
