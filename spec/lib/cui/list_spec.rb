# frozen_string_literal: true

describe CUI::List do
  let(:items) do
    {
      item1: 'Item 1',
      item2: 'Item 2',
      item3: 'Item 3'
    }
  end

  let(:settings) do
    {
      items:   items,
      header:  'Main Menu',
      footer:  'Select an option',
      default: 0,
      pointer: '=>',
      go_back: 'Back',
      quit:    'Exit'
    }
  end

  let(:list) { described_class.new(**settings) }

  around do |example|
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = StringIO.new
    $stderr = StringIO.new
    example.run
    $stdout = original_stdout
    $stderr = original_stderr
  end

  describe '#initialize' do
    it 'initializes with the correct settings' do
      expect(list.instance_variable_get(:@position)).to eq(0)
      expect(list.parent).to be_nil
      expect(list.instance_variable_get(:@items).map(&:value)).to eq(%i[quit item1 item2 item3])
      expect(list.instance_variable_get(:@items).map(&:label)).to eq(['Exit', 'Item 1', 'Item 2', 'Item 3'])
      expect(list.instance_variable_get(:@lines)).to eq(1 + 1 + 4) # header + footer + items
    end
  end

  describe '#select' do
    let(:input_keys) { [] }

    before do
      # Замокировать методы из модулей View и Control
      allow(list).to receive(:draw)
      allow(list).to receive(:clear_line)
      allow(list).to receive(:display).and_yield

      # Замокировать $stdin.raw и getc
      allow($stdin).to receive(:raw).and_yield($stdin)
      allow($stdin).to receive(:getc).and_return(*input_keys)
    end

    context 'when user selects an item' do
      let(:input_keys) { [CUI::KEY_ARROW_DOWN, CUI::KEY_RETURN] }

      it 'returns the selected item value' do
        result = list.select
        expect(result).to eq(:item1)
      end
    end

    context 'when user navigates and selects an item' do
      let(:input_keys) do
        [
          CUI::KEY_ARROW_DOWN,
          CUI::KEY_ARROW_DOWN,
          CUI::KEY_ARROW_DOWN,
          CUI::KEY_RETURN
        ]
      end

      it 'returns the correct selected item value' do
        result = list.select
        expect(result).to eq(:item3)
      end
    end

    context 'when user quits the menu' do
      let(:input_keys) { ['q'] }

      it 'returns :quit' do
        result = list.select
        expect(result).to eq(:quit)
      end
    end

    context 'when user goes back in a child menu' do
      let(:parent_list) { double('ParentList') }
      let(:list_with_parent) { described_class.new(**settings.merge(parent: parent_list)) }
      let(:input_keys) { [CUI::KEY_ARROW_LEFT] }

      it 'returns :go_back' do
        result = list_with_parent.select
        expect(result).to eq(:go_back)
      end
    end
  end

  describe '#child?' do
    context 'when parent is present' do
      let(:parent_list) { double('ParentList') }
      let(:list_with_parent) { described_class.new(**settings.merge(parent: parent_list)) }

      it 'returns true' do
        expect(list_with_parent.child?).to be true
      end
    end

    context 'when parent is nil' do
      it 'returns false' do
        expect(list.child?).to be false
      end
    end
  end

  describe '#pointer' do
    it 'returns the pointer string when index matches position' do
      expect(list.send(:pointer, 0)).to eq('=>')
    end

    it 'returns spaces when index does not match position' do
      expect(list.send(:pointer, 1)).to eq('  ')
    end
  end

  describe '#define_items' do
    it 'includes the quit option when parent is nil' do
      expect(list.instance_variable_get(:@items).first.value).to eq(:quit)
    end

    context 'when parent is present' do
      let(:parent_list) { double('ParentList') }
      let(:list_with_parent) { described_class.new(**settings.merge(parent: parent_list)) }

      it 'includes the go_back option when parent is present' do
        expect(list_with_parent.instance_variable_get(:@items).first.value).to eq(:go_back)
      end
    end
  end

  describe '#line_count' do
    it 'calculates the correct number of lines' do
      expect(list.instance_variable_get(:@lines)).to eq(1 + 1 + 4) # header + footer + items
    end
  end
end
