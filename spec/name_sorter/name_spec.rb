# frozen_string_literal: true

RSpec.describe NameSorter::Name do
  describe '.parse' do
    it 'separates given names from the last name' do
      name = described_class.parse('Hunter Uriah Mathew Clarke')

      expect(name.given_names).to eq(%w[Hunter Uriah Mathew])
      expect(name.last_name).to eq('Clarke')
    end

    it 'normalizes surrounding and repeated whitespace' do
      name = described_class.parse("  Adonis   Julius\tArcher  ")

      expect(name.to_s).to eq('Adonis Julius Archer')
    end

    it 'rejects a name without a given name' do
      expect { described_class.parse('Prince') }
        .to raise_error(NameSorter::InvalidNameError, /one to three given names/)
    end

    it 'rejects more than three given names' do
      expect { described_class.parse('One Two Three Four Last') }
        .to raise_error(NameSorter::InvalidNameError, /one to three given names/)
    end
  end

  describe '#sort_key' do
    it 'places the last name before the given names and ignores case' do
      name = described_class.parse('jANET pARSONS')

      expect(name.sort_key).to eq(%w[parsons janet])
    end
  end
end
