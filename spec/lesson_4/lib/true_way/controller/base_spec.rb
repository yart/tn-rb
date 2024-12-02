# frozen_string_literal: true

class DummyController < Lesson4::TrueWay::Controller::Base
  def test_action
    @message = 'Hello from controller!'
    # Не вызываем render
  end

  def render_action
    @message = 'Rendered from action!'
    render 'custom_template'
  end

  def lazy_action; end
end

describe Lesson4::TrueWay::Controller::Base do
  subject(:controller) { DummyController.new(**params) }

  let(:params) { { key: 'value' } }

  let(:view_double) { instance_double('Lesson4::TrueWay::View') }

  before do
    stub_const('Lesson4::TrueWay::View', Class.new { def initialize(*); end })

    allow(Lesson4::TrueWay::View).to receive(:new).and_return(view_double)
    allow(view_double).to receive(:render)
  end

  describe '#initialize' do
    it 'assigns the params' do
      expect(controller.params).to eq(params)
    end
  end

  describe '#dispatch_action' do
    context 'when the action does not call render' do
      it 'renders the default template' do
        expect(view_double).to receive(:render).with('app/views/dummy/test_action.txt.erb').once

        controller.dispatch_action(:test_action)

        expect(controller.instance_variable_get(:@message)).to eq('Hello from controller!')
      end
    end

    context 'when the action calls render with a custom template' do
      it 'renders the specified template and does not render again' do
        expect(view_double).to receive(:render).with('app/views/dummy/custom_template.txt.erb').once

        controller.dispatch_action(:render_action)

        expect(controller.instance_variable_get(:@message)).to eq('Rendered from action!')
      end
    end

    context 'when the action exists but is empty' do
      it 'renders the default template' do
        expect(view_double).to receive(:render).with('app/views/dummy/lazy_action.txt.erb').once

        controller.dispatch_action(:lazy_action)
      end
    end

    context 'when the action method is not defined' do
      it 'renders the default template for the action' do
        expect(view_double).to receive(:render).with('app/views/dummy/empty_action.txt.erb').once

        controller.dispatch_action(:empty_action)
      end
    end
  end

  describe '#derive_view_path' do
    it 'returns the correct view path' do
      derived_path = controller.send(:derive_view_path, 'show')
      expect(derived_path).to eq('app/views/dummy/show.txt.erb')
    end
  end
end
