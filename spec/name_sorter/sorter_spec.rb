# frozen_string_literal: true

RSpec.describe NameSorter::Sorter do
  subject(:sorter) { described_class.new }

  let(:parser) { NameSorter::Parser.new }

  it 'sorts by last name and then by given names' do
    names = parser.parse([
                           'Janet Parsons',
                           'Vaugh Lewis',
                           'Adonis Julius Archer',
                           'Shelby Nathan Yoder',
                           'Marin Alvarez',
                           'London Lindsey',
                           'Beau Tristan Bentley',
                           'Leo Gardner',
                           'Hunter Uriah Mathew Clarke',
                           'Mikayla Lopez',
                           'Frankie Conner Ritter'
                         ])

    sorted_names = sorter.sort(names).map(&:to_s)

    expect(sorted_names).to eq([
                                 'Marin Alvarez',
                                 'Adonis Julius Archer',
                                 'Beau Tristan Bentley',
                                 'Hunter Uriah Mathew Clarke',
                                 'Leo Gardner',
                                 'Vaugh Lewis',
                                 'London Lindsey',
                                 'Mikayla Lopez',
                                 'Janet Parsons',
                                 'Frankie Conner Ritter',
                                 'Shelby Nathan Yoder'
                               ])
  end

  it 'compares each given name when last names match' do
    names = parser.parse(['Amy Beth Zoe Smith', 'Amy Zoe Smith', 'Amy Beth Alice Smith'])
    expected_names = [
      'Amy Beth Alice Smith',
      'Amy Beth Zoe Smith',
      'Amy Zoe Smith'
    ]

    expect(sorter.sort(names).map(&:to_s)).to eq(expected_names)
  end

  it 'does not mutate the input collection' do
    names = parser.parse(['Zoe Smith', 'Amy Smith'])

    sorter.sort(names)

    expect(names.map(&:to_s)).to eq(['Zoe Smith', 'Amy Smith'])
  end
end
