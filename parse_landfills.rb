#!/usr/bin/env ruby

def write_and_reassign(local_county, local_state)
  if local_county != @county
    @out_file.write "#{@county},#{@state},#{@num_dump}\n" if @county != ''
     @county = local_county
     @state  = local_state
     @num_dump = 0
  end

  @num_dump += 1
end

# this text file was generated with ps2pdf from the MSW pdf original
file = open('MSW_sites.txt')
@out_file = File.new('output.txt', 'w')
@out_file.write "county,state,num_dump\n"

# variable initialization
@num_dump = 0
@county, @state = ''

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
  else
    # Garbage
  end
end

file.close
@out_file.close

