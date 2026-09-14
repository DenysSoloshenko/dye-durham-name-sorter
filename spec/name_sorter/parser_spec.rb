# frozen_string_literal: true

RSpec.describe NameSorter::Parser do
  subject(:parser) { described_class.new }

  it 'parses non-empty lines' do
    names = parser.parse(["Janet Parsons\n", '  ', "Leo Gardner\n"])

    expect(names.map(&:to_s)).to eq(['Janet Parsons', 'Leo Gardner'])
  end

  it 'includes the source line number in validation errors' do
    expect { parser.parse(['Janet Parsons', 'Invalid']) }
      .to raise_error(NameSorter::InvalidNameError, /^line 2:/)
  end
end
