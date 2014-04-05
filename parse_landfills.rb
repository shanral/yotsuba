#!/usr/bin/env ruby

def write_and_reassign(local_county, local_state)
  # when the county changes:
  # 1. write the county/number of dumps to CSV
  # 2. reset county, state, and number of dump variables
  if local_county != @county
    write_to_file
    reassign_variables(local_county, local_state)
  end

  @num_dump += 1
end

def write_to_file
  @out_file.write "#{@county},#{@state},#{@num_dump}\n" if @county != ''
end

def reassign_variables(local_county, local_state)
  @county = local_county
  @state  = local_state
  @num_dump = 0
end

# initialize output file
@out_file = File.new('output.txt', 'w')
@out_file.write "county,state,num_dump\n"

# variable initialization
@num_dump = 0
@county, @state = ''

# this text file was generated with ps2pdf from the MSW pdf original
file = open('MSW_sites.txt')
file.each_line do |line|
  chunks = line.chomp.split(/\s{2,}/)

  # conditionals to account for various types of formatting in the original
  if (chunks.length == 5 && chunks[0] =~ /\s?\d+/)
    if chunks[4] =~ /\d+/
      write_and_reassign(chunks[2], chunks[3])
    else
      write_and_reassign(chunks[3], chunks[4])
    end
  elsif (chunks.length == 6 && chunks[0] =~ /\s?\d+/)
    write_and_reassign(chunks[3], chunks[4])
  elsif (chunks.length == 4 || chunks.length == 3) && chunks [0] =~ /\s?\d+/
    write_and_reassign(chunks[-2], chunks[-1])
  end
end

file.close
@out_file.close

