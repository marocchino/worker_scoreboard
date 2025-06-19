require 'spec_helper'
require 'tmpdir'

describe WorkerScoreboard do
  describe '.new' do
    context 'For nested directory' do
      let(:base_dir) { File.join(Dir.tmpdir, 'level1', 'level2') }
      subject { WorkerScoreboard.new(base_dir) }
      example do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe '#update' do
    let(:base_dir) { Dir.tmpdir }
    subject { WorkerScoreboard.new(base_dir) }

    it 'creates a file with the given name and content with only ascii content' do
      subject.update('me manager')
      expect(subject.read_all.values.first).to eq 'me manager'
    end

    it 'creates a file with the given name and content with utf-8 content' do
      subject.update('俺マネージャー👨🏿‍💼')
      expect(subject.read_all.values.first).to eq '俺マネージャー👨🏿‍💼'
    end

    it 'creates a file with the given name and content with shift-jis content' do
      subject.update('俺マネージャー'.encode('Shift_JIS'))
      expect(subject.read_all.values.first).to eq '俺マネージャー'
    end

    it 'creates a file with the given name and content with euc-jp content' do
      subject.update('俺マネージャー'.encode('EUC-JP'))
      expect(subject.read_all.values.first).to eq '俺マネージャー'
    end
  end
end
