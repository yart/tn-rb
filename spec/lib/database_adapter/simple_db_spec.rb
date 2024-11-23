# frozen_string_literal: true

require 'fileutils'

RSpec.describe DatabaseAdapter::SimpleDB do
  let(:db_path) { './spec/test_db' }
  let(:adapter) { described_class.new(path: db_path) }

  before do
    FileUtils.rm_rf(db_path)
    FileUtils.mkdir_p(db_path)
  end

  after { FileUtils.rm_rf(db_path) }

  describe '#create' do
    it 'creates a new record and returns its ID' do
      id = adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
      expect(File.exist?("#{db_path}/users/#{id}")).to be true
    end

    it 'stores attributes in the created file' do
      id = adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
      data = YAML.load_file("#{db_path}/users/#{id}")
      expect(data).to eq({ name: 'John', age: 30 })
    end
  end

  describe '#find' do
    it 'returns the record if it exists' do
      id = adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
      record = adapter.find(table: 'users', id: id)
      expect(record).to eq({ name: 'John', age: 30, id: id })
    end

    it 'returns nil if the record does not exist' do
      expect(adapter.find(table: 'users', id: 'nonexistent')).to be_nil
    end
  end

  describe '#all' do
    it 'returns all records in the table' do
      adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
      adapter.create(table: 'users', attributes: { name: 'Jane', age: 25 })
      records = adapter.all(table: 'users')
      expect(records.size).to eq(2)
      expect(records.map { |r| r[:name] }).to contain_exactly('John', 'Jane')
    end

    it 'returns an empty array if the table is empty' do
      expect(adapter.all(table: 'users')).to eq([])
    end
  end

  describe '#update' do
    it 'updates an existing record' do
      id = adapter.create(table: 'users', attributes: {name: 'John', age: 30})
      adapter.update(table: 'users', id: id, attributes: {name: 'Johnny', age: 31})
      record = adapter.find(table: 'users', id: id)
      expect(record).to eq({name: 'Johnny', age: 31, id: id})
    end
  end

  describe '#delete' do
    it 'deletes an existing record' do
      id = adapter.create(table: 'users', attributes: { name: 'John', age: 30 })
      adapter.delete(table: 'users', id: id)
      expect(adapter.find(table: 'users', id: id)).to be_nil
      expect(File.exist?("#{db_path}/users/#{id}")).to be false
    end

    it 'does nothing if the record does not exist' do
      expect { adapter.delete(table: 'users', id: 'nonexistent') }.not_to raise_error
    end
  end
end