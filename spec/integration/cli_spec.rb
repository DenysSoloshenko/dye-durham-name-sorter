# frozen_string_literal: true

require 'open3'
require 'tmpdir'

RSpec.describe 'name-sorter executable' do
  let(:executable) { File.expand_path('../../bin/name-sorter', __dir__) }
  let(:directory) { @temporary_directory }

  around do |example|
    Dir.mktmpdir('name-sorter') do |temporary_directory|
      @temporary_directory = temporary_directory
      example.run
    end
  end

  it 'prints sorted names and overwrites the output file' do
    input_path = File.join(directory, 'unsorted-names-list.txt')
    output_path = File.join(directory, 'sorted-names-list.txt')
    File.write(input_path, "Janet Parsons\nMarin Alvarez\nAdonis Julius Archer\n")
    File.write(output_path, 'stale content')

    stdout, stderr, status = Open3.capture3(executable, input_path, chdir: directory)
    expected_output = "Marin Alvarez\nAdonis Julius Archer\nJanet Parsons\n"

    expect(status).to be_success
    expect(stderr).to be_empty
    expect(stdout).to eq(expected_output)
    expect(File.read(output_path)).to eq(expected_output)
  end

  it 'reports invalid arguments without creating an output file' do
    _stdout, stderr, status = Open3.capture3(executable, chdir: directory)

    expect(status.exitstatus).to eq(1)
    expect(stderr).to include('Usage: name-sorter')
    expect(File).not_to exist(File.join(directory, 'sorted-names-list.txt'))
  end

  it 'reports a missing input file' do
    input_path = File.join(directory, 'missing.txt')

    stdout, stderr, status = Open3.capture3(executable, input_path, chdir: directory)

    expect(status.exitstatus).to eq(1)
    expect(stdout).to be_empty
    expect(stderr).to include("input file not found: #{input_path}")
  end

  it 'reports an invalid name without overwriting an existing result' do
    input_path = File.join(directory, 'unsorted-names-list.txt')
    output_path = File.join(directory, 'sorted-names-list.txt')
    File.write(input_path, "Janet Parsons\nInvalid\n")
    File.write(output_path, 'previous result')

    stdout, stderr, status = Open3.capture3(executable, input_path, chdir: directory)

    expect(status.exitstatus).to eq(1)
    expect(stdout).to be_empty
    expect(stderr).to include('Error: line 2:')
    expect(File.read(output_path)).to eq('previous result')
  end

  it 'ignores a UTF-8 byte order mark' do
    input_path = File.join(directory, 'unsorted-names-list.txt')
    File.binwrite(input_path, "\xEF\xBB\xBFAmy Smith\nAnn Smith\n")

    stdout, stderr, status = Open3.capture3(executable, input_path, chdir: directory)

    expect(status).to be_success
    expect(stderr).to be_empty
    expect(stdout).to eq("Amy Smith\nAnn Smith\n")
  end

  it 'reports invalid UTF-8 without printing a backtrace' do
    input_path = File.join(directory, 'unsorted-names-list.txt')
    File.binwrite(input_path, "Amy Smith\nInvalid\xFF Name\n")

    stdout, stderr, status = Open3.capture3(executable, input_path, chdir: directory)

    expect(status.exitstatus).to eq(1)
    expect(stdout).to be_empty
    expect(stderr).to eq("Error: input file must contain valid UTF-8 text\n")
  end
end
