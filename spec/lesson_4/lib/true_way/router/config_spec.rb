# frozen_string_literal: true

describe Lesson4::TrueWay::Router::Config do
  let(:router_instance) { Lesson4::TrueWay::Router }

  describe 'RouteDSL' do
    let(:dsl) { Lesson4::TrueWay::Router::Config::RouteDSL.new }

    it 'adds routes using set method in DSL context' do
      expect { dsl.set '/stations/list' }.to change { router_instance.routes.size }.by(1)
      expect(router_instance.routes.keys).to include(%r{^/stations/list$})
    end

    it 'raises an error for duplicate routes' do
      dsl.set('/controller/action')

      expect { dsl.set('/controller/action') }.to raise_error(Lesson4::TrueWay::Router::Error::DuplicateRouteError)
    end
  end

  describe '.load_routes' do
    it 'loads routes from a given file using DSL context' do
      routes = <<~ROUTES
        set '/stations/add', to: 'stations#add'
        set '/stations/:id/edit'
      ROUTES

      allow(File).to receive(:read).with('config/routes.rb').and_return(routes)

      expect { Lesson4::TrueWay::Router::Config.load_routes('config/routes.rb') }.to change { router_instance.routes.size }.by(2)
    end
  end
end
