# frozen_string_literal: true

describe Lesson4::TrueWay::Router do
  let(:router) { described_class }
  let(:mocked_main_menu_controller) { instance_spy('MainMenuController') }
  let(:mocked_stations_controller) { instance_spy('StationsController') }
  let(:routes_file) { 'config/routes.rb' }

  before do
    stub_const('MainMenuController', create_controller_class)
    stub_const('StationsController', create_controller_class)

    allow(MainMenuController).to receive(:new).with(anything).and_return(mocked_main_menu_controller)
    allow(StationsController).to receive(:new).with(anything).and_return(mocked_stations_controller)
  end

  describe '.route' do
    before do
      router.reset!

      routes_list = <<~ROUTES
        set '/', to: 'main_menu#list'
        set '/stations/list'
        set '/stations/add', to: 'stations#add'
        set '/stations/:id/edit'
      ROUTES

      Lesson4::TrueWay::Config.routes_path = routes_file
      allow(File).to receive(:read).with(routes_file).and_return(routes_list)

      router.draw
    end

    context 'when routing to the root path' do
      it 'routes to MainMenuController#list' do
        router.route('/')
        expect(mocked_main_menu_controller).to have_received(:list)
      end
    end

    context 'when routing to a named controller action' do
      it 'routes to StationsController#list' do
        router.route('/stations/list')
        expect(mocked_stations_controller).to have_received(:list)
      end
    end

    context 'when routing with query parameters' do
      it 'routes to StationsController#add and passes query' do
        allow(mocked_stations_controller).to receive(:new).with(hash_including(query: { name: 'Central' }))
        router.route('/stations/add?name=Central')
        expect(mocked_stations_controller).to have_received(:add)
      end
    end

    context 'when routing with dynamic segments' do
      it 'routes to StationsController#edit and passes :id and query' do
        allow(mocked_stations_controller).to receive(:new).with(hash_including(id: '42', query: { key: 'value' }))
        router.route('/stations/42/edit?key=value')
        expect(mocked_stations_controller).to have_received(:edit)
      end
    end

    context 'when the route is not defined' do
      it 'raises a RouteNotFoundError' do
        expect { router.route('/unknown/path') }.to raise_error(Lesson4::TrueWay::Router::Error::RouteNotFoundError)
      end
    end

    context 'when route contains invalid characters' do
      it 'raises an InvalidRouteFormatError' do
        expect { router.route('/stations/@list') }.to raise_error(Lesson4::TrueWay::Router::Error::InvalidRouteFormatError)
        expect { router.route('/stations /list') }.to raise_error(Lesson4::TrueWay::Router::Error::InvalidRouteFormatError)
        expect { router.route('/stations/list!') }.to raise_error(Lesson4::TrueWay::Router::Error::InvalidRouteFormatError)
      end
    end
  end

  describe 'additional tests for edge cases' do
    context 'with invalid routes' do
      it 'raises an InvalidRouteFormatError for invalid route templates' do
        invalid_routes = [
          '/stations/:/edit',
          '',
          '/stations/{edit}'
        ]

        invalid_routes.each do |route|
          expect { router.route(route) }.to raise_error(Lesson4::TrueWay::Router::Error::InvalidRouteFormatError)
        end
      end
    end

    context 'when handling a large volume of routes' do
      it 'handles 1000 routes without performance issues' do
        router.reset!

        routes = (1..1000).map { |i| "set '/route/#{i}', to: 'controller##{i}'" }.join("\n")
        allow(File).to receive(:read).with(routes_file).and_return(routes)

        expect { router.draw }.not_to raise_error
        expect(router.routes.size).to eq(1000)
      end
    end

    context 'with complex query strings' do
      it 'parses complex query strings correctly' do
        routes_list = <<~ROUTES
          set '/stations/add', to: 'stations#add'
        ROUTES
        allow(File).to receive(:read).with(routes_file).and_return(routes_list)
        router.draw

        router.route('/stations/add?a=1&b=&=c')
        expect(mocked_stations_controller).to have_received(:add)
      end
    end

    describe 'performance under load' do
      it 'resolves routes quickly for 1000 routes' do
        router.reset!
        stub_controllers_and_routes(1000, routes_file)
        router.draw

        start_time = Time.now
        1000.times { router.route('/route999/add') }
        elapsed_time = Time.now - start_time

        expect(elapsed_time).to be < 1
      end
    end
  end

  describe '.draw' do
    it 'loads routes from config/routes.rb' do
      router.reset!

      routes = <<~ROUTES
        set '/stations/add', to: 'stations#add'
      ROUTES
      allow(File).to receive(:read).with(routes_file).and_return(routes)

      expect { router.draw }.not_to raise_error
      expect(router.routes.keys).to include(%r{^/stations/add$})
    end

    context 'when the routes file is missing or empty' do
      it 'raises a RoutesFileNotFoundError for missing file' do
        router.reset!

        allow(File).to receive(:read).with(routes_file).and_raise(Errno::ENOENT)
        expect { router.draw }.to raise_error(Lesson4::TrueWay::Router::Error::RoutesFileNotFoundError)
      end

      it 'raises a RoutesFileNotFoundError for empty routes file' do
        router.reset!

        allow(File).to receive(:read).with(routes_file).and_return('')
        allow(Lesson4::TrueWay::Router::Config).to receive(:load_routes).and_raise(Lesson4::TrueWay::Router::Error::RoutesFileNotFoundError.new(routes_file))

        expect { router.draw }.to raise_error(Lesson4::TrueWay::Router::Error::RoutesFileNotFoundError)
      end
    end
  end

  def create_routes(number)
    (1..number).map { |i| "set '/route#{i}/add', to: 'controller#{i}#add'" }.join("\n")
  end

  def stub_controllers_and_routes(number, routes_file)
    allow(File).to receive(:read).with(routes_file).and_return(create_routes(number))
    create_and_stub_controllers(number)
  end

  def create_and_stub_controllers(number)
    (1..number).each do |i|
      stub_controller(i)
    end
  end

  def stub_controller(number)
    controller_class = create_controller_class
    stub_const("Controller#{number}Controller", controller_class)
    allow(Lesson4::TrueWay::Router::ControllerFactory).to receive(:get_controller).with("controller#{number}").and_return(controller_class)
    allow(controller_class).to receive(:new).and_return(controller_class.new)
    allow(controller_class.new).to receive(:add)
  end

  def create_controller_class
    Class.new do
      def initialize(*); end
      def add; end
    end
  end
end
