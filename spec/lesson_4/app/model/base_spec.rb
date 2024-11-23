# frozen_string_literal: true

describe Lesson4::App::Model::Base do
  let(:db_path) { './spec/test_db' }
  let(:db_adapter) { DatabaseAdapter::SimpleDB.new(path: db_path) }

  before do
    FileUtils.rm_rf(db_path) # Удалить тестовую базу данных
    FileUtils.mkdir_p(db_path)
    described_class.db_adapter = db_adapter

    # Явно установить адаптер для TestModel
    TestModel.db_adapter = db_adapter
  end

  after { FileUtils.rm_rf(db_path) }

  class TestModel < Lesson4::App::Model::Base; end

  describe '.create' do
    it 'creates a new record and returns an instance' do
      instance = TestModel.create(name: 'Test Name', age: 25)
      expect(instance).to be_a(TestModel)
      expect(instance.attributes[:name]).to eq('Test Name')
      expect(instance.attributes[:age]).to eq(25)
    end

    it 'persists the record in the database' do
      instance = TestModel.create(name: 'Persistent Test', age: 30)
      stored_record = db_adapter.find(table: 'test_models', id: instance.id)
      expect(stored_record).to eq({ name: 'Persistent Test', age: 30, id: instance.id })
    end
  end

  describe '.find' do
    it 'returns an instance if the record exists' do
      id = db_adapter.create(table: 'test_models', attributes: { name: 'Find Test', age: 40 })
      instance = TestModel.find(id)
      expect(instance).to be_a(TestModel)
      expect(instance.id).to eq(id)
      expect(instance.attributes[:name]).to eq('Find Test')
    end

    it 'returns nil if the record does not exist' do
      expect(TestModel.find('nonexistent-id')).to be_nil
    end
  end

  describe '.all' do
    it 'returns all records as instances' do
      db_adapter.create(table: 'test_models', attributes: { name: 'All Test 1', age: 20 })
      db_adapter.create(table: 'test_models', attributes: { name: 'All Test 2', age: 25 })
      instances = TestModel.all
      expect(instances.size).to eq(2)
      expect(instances.map { |i| i.attributes[:name] }).to contain_exactly('All Test 1', 'All Test 2')
    end

    it 'returns an empty array if there are no records' do
      expect(TestModel.all).to eq([])
    end
  end

  describe '#save' do
    it 'creates a new record if ID is not present' do
      instance = TestModel.new(name: 'Save Test', age: 50)
      expect(instance.id).to be_nil
      instance.save
      expect(instance.id).not_to be_nil
      stored_record = db_adapter.find(table: 'test_models', id: instance.id)
      expect(stored_record[:name]).to eq('Save Test')
    end

    it 'updates an existing record if ID is present' do
      instance = TestModel.create(name: 'Old Name', age: 60)
      instance.attributes[:name] = 'Updated Name'
      instance.save
      stored_record = db_adapter.find(table: 'test_models', id: instance.id)
      expect(stored_record[:name]).to eq('Updated Name')
    end
  end

  describe '#destroy' do
    it 'removes the record from the database' do
      instance = TestModel.create(name: 'Destroy Test', age: 35)
      id = instance.id
      instance.destroy
      expect(db_adapter.find(table: 'test_models', id: id)).to be_nil
    end
  end
end
