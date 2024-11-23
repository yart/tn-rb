# frozen_string_literal: true

describe DatabaseAdapter::Base do
  subject(:base_adapter) { described_class.new }

  it 'raises NotImplementedError for #find' do
    expect { base_adapter.find(table: 'users', id: 'some-id') }.to raise_error(NotImplementedError)
  end

  it 'raises NotImplementedError for #all' do
    expect { base_adapter.all(table: 'users') }.to raise_error(NotImplementedError)
  end

  it 'raises NotImplementedError for #create' do
    expect { base_adapter.create(table: 'users', attributes: { name: 'John' }) }.to raise_error(NotImplementedError)
  end

  it 'raises NotImplementedError for #update' do
    expect { base_adapter.update(table: 'users', id: 'some-id', attributes: { name: 'Jane' }) }.to raise_error(NotImplementedError)
  end

  it 'raises NotImplementedError for #delete' do
    expect { base_adapter.delete(table: 'users', id: 'some-id') }.to raise_error(NotImplementedError)
  end
end
