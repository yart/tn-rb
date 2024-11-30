# frozen_string_literal: true

RSpec.describe Lesson4::TrueWay::Router::Error do
  describe Lesson4::TrueWay::Router::Error::RouteNotFoundError do
    it 'raises with the correct message' do
      path = '/invalid/path'
      expect { raise described_class.new(path) }
        .to raise_error(Lesson4::TrueWay::Router::Error::RouteNotFoundError, "Route not found: #{path}")
    end
  end

  describe Lesson4::TrueWay::Router::Error::InvalidRouteFormatError do
    it 'raises with the correct message' do
      path = 'invalid_format'
      expect { raise described_class.new(path) }
        .to raise_error(Lesson4::TrueWay::Router::Error::InvalidRouteFormatError, "Invalid route format: #{path}")
    end
  end

  describe Lesson4::TrueWay::Router::Error::RoutesFileNotFoundError do
    it 'raises with the correct message' do
      file = 'missing_file.rb'
      expect { raise described_class.new(file) }
        .to raise_error(Lesson4::TrueWay::Router::Error::RoutesFileNotFoundError, "Routes file not found: #{file}")
    end
  end

  describe Lesson4::TrueWay::Router::Error::ControllerNotFoundError do
    it 'raises with the default message' do
      expect { raise described_class.new }
        .to raise_error(Lesson4::TrueWay::Router::Error::ControllerNotFoundError, 'Controller not found')
    end
  end

  describe Lesson4::TrueWay::Router::Error::DuplicateRouteError do
    it 'raises with the correct message' do
      path = '/duplicate/path'
      expect { raise described_class.new(path) }
        .to raise_error(Lesson4::TrueWay::Router::Error::DuplicateRouteError, "Duplicate route: #{path}")
    end
  end
end
