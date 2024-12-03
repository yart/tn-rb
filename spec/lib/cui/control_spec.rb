# frozen_string_literal: true

class TestControl
  include CUI::Control

  public(*private_instance_methods)

  attr_accessor :key, :position, :items, :parent

  def initialize
    @position = 0
    @items    = []
    @parent   = nil
    @key      = nil
  end

  def child?
    !@parent.nil?
  end
end

describe TestControl do
  let(:test_control) { described_class.new }

  describe '#selection' do
    before do
      test_control.items = [
        CUI::List::Item.new(:item1, 'Item 1'),
        CUI::List::Item.new(:item2, 'Item 2')
      ]
    end

    context 'when go_back? is true and child? is true' do
      it 'returns :go_back' do
        test_control.key = CUI::KEY_ARROW_LEFT
        test_control.parent = double('Parent')
        allow(test_control).to receive(:go_back?).and_return(true)
        allow(test_control).to receive(:child?).and_return(true)
        expect(test_control.send(:selection)).to eq(:go_back)
      end
    end

    context 'when go_back? is true and child? is false' do
      it 'returns :quit' do
        test_control.key = CUI::KEY_ARROW_LEFT
        allow(test_control).to receive(:go_back?).and_return(true)
        allow(test_control).to receive(:child?).and_return(false)
        expect(test_control.send(:selection)).to eq(:quit)
      end
    end

    context 'when quit? is true' do
      it 'returns :quit' do
        test_control.key = 'q'
        allow(test_control).to receive(:quit?).and_return(true)
        expect(test_control.send(:selection)).to eq(:quit)
      end
    end

    context 'when neither go_back? nor quit? is true' do
      it 'returns the label of the currently selected item' do
        test_control.position = 1
        expect(test_control.send(:selection)).to eq(:item2)
      end
    end
  end

  describe '#read_char' do
    before do
      @original_stdin = $stdin
      $stdin = double('stdin')
      allow($stdin).to receive(:raw).and_yield($stdin)
    end

    after do
      $stdin = @original_stdin
    end

    it 'reads a single character input' do
      allow($stdin).to receive(:getc).and_return('a')
      test_control.send(:read_char)
      expect(test_control.key).to eq('a')
    end

    it 'reads an escape sequence' do
      chars = ["\e", '[', 'A', nil]
      allow($stdin).to receive(:getc).and_return(*chars)
      test_control.send(:read_char)
      expect(test_control.key).to eq("\e[A")
    end
  end

  describe '#move_pointer' do
    before do
      test_control.items = [
        CUI::List::Item.new(:item1, 'Item 1'),
        CUI::List::Item.new(:item2, 'Item 2'),
        CUI::List::Item.new(:item3, 'Item 3')
      ]
    end

    it 'moves down when move_down? is true and not at last line' do
      test_control.position = 0
      allow(test_control).to receive(:move_down?).and_return(true)
      allow(test_control).to receive(:last_line?).and_return(false)
      test_control.send(:move_pointer)
      expect(test_control.position).to eq(1)
    end

    it 'does not move down when at last line' do
      test_control.position = 2
      allow(test_control).to receive(:move_down?).and_return(true)
      allow(test_control).to receive(:last_line?).and_return(true)
      test_control.send(:move_pointer)
      expect(test_control.position).to eq(2)
    end

    it 'moves up when move_up? is true and not at first line' do
      test_control.position = 2
      allow(test_control).to receive(:move_up?).and_return(true)
      allow(test_control).to receive(:first_line?).and_return(false)
      test_control.send(:move_pointer)
      expect(test_control.position).to eq(1)
    end

    it 'does not move up when at first line' do
      test_control.position = 0
      allow(test_control).to receive(:move_up?).and_return(true)
      allow(test_control).to receive(:first_line?).and_return(true)
      test_control.send(:move_pointer)
      expect(test_control.position).to eq(0)
    end
  end

  describe 'movement methods' do
    before do
      test_control.key = nil
    end

    describe '#move_up?' do
      it 'returns true when key is KEY_ARROW_UP' do
        test_control.key = CUI::KEY_ARROW_UP
        expect(test_control.move_up?).to be true
      end

      it 'returns true when key matches KEY_UP_RE' do
        test_control.key = 'k'
        expect(test_control.move_up?).to be true
      end

      it 'returns false otherwise' do
        test_control.key = 'x'
        expect(test_control.move_up?).to be false
      end
    end

    describe '#move_down?' do
      it 'returns true when key is KEY_ARROW_DOWN' do
        test_control.key = CUI::KEY_ARROW_DOWN
        expect(test_control.move_down?).to be true
      end

      it 'returns true when key matches KEY_DOWN_RE' do
        test_control.key = 'j'
        expect(test_control.move_down?).to be true
      end

      it 'returns false otherwise' do
        test_control.key = 'x'
        expect(test_control.move_down?).to be false
      end
    end

    describe '#select?' do
      it 'returns true when key is KEY_ARROW_RIGHT' do
        test_control.key = CUI::KEY_ARROW_RIGHT
        expect(test_control.select?).to be true
      end

      it 'returns true when key matches KEY_RIGHT_RE' do
        test_control.key = 'd'
        expect(test_control.select?).to be true
      end

      it 'returns true when key is KEY_RETURN' do
        test_control.key = CUI::KEY_RETURN
        expect(test_control.select?).to be true
      end

      it 'returns false otherwise' do
        test_control.key = 'x'
        expect(test_control.select?).to be false
      end
    end

    describe '#go_back?' do
      it 'returns true when key is KEY_ARROW_LEFT' do
        test_control.key = CUI::KEY_ARROW_LEFT
        expect(test_control.go_back?).to be true
      end

      it 'returns true when key matches KEY_LEFT_RE' do
        test_control.key = 'a'
        expect(test_control.go_back?).to be true
      end

      it 'returns false otherwise' do
        test_control.key = 'x'
        expect(test_control.go_back?).to be false
      end
    end

    describe '#quit?' do
      it 'returns true when key is QUICK_QUIT' do
        test_control.key = CUI::QUICK_QUIT
        expect(test_control.quit?).to be true
      end

      it 'returns true when key matches KEY_QUIT_RE' do
        test_control.key = 'q'
        expect(test_control.quit?).to be true
      end

      it 'returns false otherwise' do
        test_control.key = 'x'
        expect(test_control.quit?).to be false
      end
    end
  end

  describe 'position methods' do
    before do
      test_control.items = [
        CUI::List::Item.new(:item1, 'Item 1'),
        CUI::List::Item.new(:item2, 'Item 2'),
        CUI::List::Item.new(:item3, 'Item 3')
      ]
    end

    describe '#first_line?' do
      it 'returns true when position is zero' do
        test_control.position = 0
        expect(test_control.first_line?).to be true
      end

      it 'returns false when position is not zero' do
        test_control.position = 1
        expect(test_control.first_line?).to be false
      end
    end

    describe '#last_line?' do
      it 'returns true when position is at last item' do
        test_control.position = 2
        expect(test_control.last_line?).to be true
      end

      it 'returns false when position is not at last item' do
        test_control.position = 1
        expect(test_control.last_line?).to be false
      end
    end
  end
end
