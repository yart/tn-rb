# frozen_string_literal: true

class TestView
  include CUI::View

  def execute_private_method(method_name, *args, **kwargs, &block)
    method = private_methods.include?(method_name) ? method_name : nil
    raise NoMethodError, "undefined method `#{method_name}`" unless method

    method(method).call(*args, **kwargs, &block)
  end
end

RSpec.describe CUI::View do
  let(:test_view) { TestView.new }

  describe '#draw' do
    context 'when new_line is true' do
      it 'outputs the element with a newline' do
        expect { test_view.execute_private_method(:draw, 'Hello, World!') }.to output("Hello, World!\n").to_stdout
      end
    end

    context 'when new_line is false' do
      it 'outputs the element without a newline' do
        expect { test_view.execute_private_method(:draw, 'Hello, World!', new_line: false) }.to output('Hello, World!').to_stdout
      end
    end

    context 'when element is nil' do
      it 'does not output anything' do
        expect { test_view.execute_private_method(:draw, nil) }.not_to output.to_stdout
      end
    end
  end

  describe '#hide_tty_cursor' do
    it 'outputs the HIDE_CURSOR sequence without a newline' do
      expect { test_view.execute_private_method(:hide_tty_cursor) }.to output(CUI::HIDE_CURSOR).to_stdout
    end
  end

  describe '#show_tty_cursor' do
    it 'outputs the SHOW_CURSOR sequence without a newline' do
      expect { test_view.execute_private_method(:show_tty_cursor) }.to output(CUI::SHOW_CURSOR).to_stdout
    end
  end

  describe '#clear_line' do
    it 'outputs the CLEAR_LINE sequence without a newline' do
      expect { test_view.execute_private_method(:clear_line) }.to output(CUI::CLEAR_LINE).to_stdout
    end
  end

  describe '#display' do
    it 'hides the cursor, yields to block, then shows the cursor' do
      block_executed = false
      expect do
        test_view.execute_private_method(:display) do
          block_executed = true
        end
      end.to output(CUI::HIDE_CURSOR + CUI::SHOW_CURSOR).to_stdout
      expect(block_executed).to be true
    end

    it 'ensures cursor is shown even if an exception is raised' do
      expect do
        test_view.execute_private_method(:display) do
          raise 'Test Exception'
        end
      end.to raise_error('Test Exception').and output(/#{Regexp.escape(CUI::HIDE_CURSOR)}.*#{Regexp.escape(CUI::SHOW_CURSOR)}/m).to_stdout
    end

    it 'restores $stdout.sync after execution' do
      original_sync = $stdout.sync
      test_view.execute_private_method(:display) do
        expect($stdout.sync).to be true
      end
      expect($stdout.sync).to eq(original_sync)
    end
  end
end
