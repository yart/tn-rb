# frozen_string_literal: true

describe Lesson4::App::Router::Config do
  let(:dsl) { described_class }
  let(:router_instance) { Lesson4::App::Router }

  describe '.set' do
    it 'adds a route to the router' do
      expect { dsl.set '/stations/list' }.to change { router_instance.routes.size }.by(1)
      expect(router_instance.routes.keys).to include(%r{^/stations/list$})
    end

    it 'raises an error for duplicate routes' do
      dsl.set '/controller/action'

      expect { dsl.set '/controller/action' }.to raise_error(Lesson4::App::Router::RoutingError)
    end
  end

  describe '.load_routes' do
    it 'loads routes from the given file and evaluates them' do
      routes = <<~ROUTES
        set '/stations/add', to: 'stations#add'
        set '/stations/:id/edit'
      ROUTES

      allow(File).to receive(:read).with('config/routes.rb').and_return(routes)

      expect { dsl.load_routes('config/routes.rb') }.to change { router_instance.routes.size }.by(2)
    end
  end
end
