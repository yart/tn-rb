# frozen_string_literal: true

describe Lesson4::App::Router do
  let(:router) { described_class }
  let(:controller_double) { instance_double('Controller') }
  let(:routes_file) { 'config/routes.rb' }

  before do
    stub_const('MainMenuController', Class.new)
    stub_const('StationsController', Class.new)
    allow(MainMenuController).to receive(:new).and_return(controller_double)
    allow(StationsController).to receive(:new).and_return(controller_double)
  end

  describe '.route' do
    before do
      routes_list = <<~ROUTES
        set '/', to: 'main_menu#list'
        set '/stations/list'
        set '/stations/add', to: 'stations#add'
        set '/stations/:id/edit'
      ROUTES

      allow(App::Router::Config).to receive(:load_routes).and_call_original
      allow(File).to receive(:read).with(routes_file).and_return(routes_list)

      router.draw
    end

    context 'when routing to the root path' do
      it 'routes to MainMenuController#list' do
        expect(controller_double).to receive(:list)
        router.route('/')
      end
    end

    context 'when routing to a named controller action' do
      it 'routes to StationsController#list' do
        expect(controller_double).to receive(:list)
        router.route('/stations/list')
      end
    end

    context 'when routing with query parameters' do
      it 'routes to StationsController#add and passes query' do
        expect(StationsController).to receive(:new).with(hash_including(query: 'name=Central'))
        expect(controller_double).to receive(:add)
        router.route('/stations/add?name=Central')
      end
    end

    context 'when routing with dynamic segments' do
      it 'routes to StationsController#edit and passes :id and query' do
        expect(StationsController).to receive(:new).with(hash_including(id: '42', query: 'key=value'))
        expect(controller_double).to receive(:edit)
        router.route('/stations/42/edit?key=value')
      end
    end

    context 'when the route is not defined' do
      it 'raises a routing error' do
        expect { router.route('/unknown/path') }.to raise_error(App::Router::RoutingError)
      end
    end

    context 'when route contains invalid characters' do
      it 'raises a routing error for invalid path format' do
        expect { router.route('/stations/@list') }.to raise_error(App::Router::RoutingError)
        expect { router.route('/stations /list') }.to raise_error(App::Router::RoutingError)
        expect { router.route('/stations/list!') }.to raise_error(App::Router::RoutingError)
      end
    end
  end

  describe '.draw' do
    it 'loads routes from config/routes.rb' do
      routes_list = <<~ROUTES
        set '/stations/add', to: 'stations#add'
      ROUTES
      allow(File).to receive(:read).with(routes_file).and_return(routes_list)

      expect { router.draw }.not_to raise_error
      expect(router.routes).to include('/stations/add')
    end

    context 'when the routes file is missing or empty' do
      it 'raises an error for missing file' do
        allow(File).to receive(:read).with(routes_file).and_raise(Errno::ENOENT)
        expect { router.draw }.to raise_error(App::Router::RoutingError)
      end

      it 'raises an error for empty routes file' do
        allow(File).to receive(:read).with(routes_file).and_return('')
        expect { router.draw }.to raise_error(App::Router::RoutingError)
      end
    end
  end
end
