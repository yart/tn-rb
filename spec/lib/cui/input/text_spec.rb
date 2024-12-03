# frozen_string_literal: true

describe CUI::Input::Text do
  describe '.show_prompt' do
    context 'when instance created with default settings' do
      subject { described_class.new.send(:show_prompt) }

      it('shows "> " as prompt') { expect { subject }.to output('> ').to_stdout }
    end

    context 'when instance created with the label param' do
      subject { described_class.new(label: 'Test').send(:show_prompt) }

      it('shows "Test >" as prompt') { expect { subject }.to output('Test > ').to_stdout }
    end

    context 'when instance created with the prompt param' do
      subject { described_class.new(prompt: ': ').send(:show_prompt) }

      it('shows ": " as prompt') { expect { subject }.to output(': ').to_stdout }
    end
  end

  describe '.receive' do
    subject { described_class.new }

    before { allow(subject).to receive(:gets).and_return('test') }

    it('clears the stdout when user input received') { expect { subject.receive }.to output("> \r\e[A\e[K").to_stdout }

    it 'returns the user input' do
      # Supprising any output
      [$stdout, subject].each { |object| allow(object).to receive(:print) }

      expect(subject.receive).to eq 'test'
    end
  end
end
