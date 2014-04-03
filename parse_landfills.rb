#!/usr/bin/env ruby

def write_and_reassign
  if @local_county != @county
    @out_file.write "#{@county},#{@state},#{@num_dump}\n" if @county != ''
     @county = @local_county
     @state  = @local_state
     @num_dump = 0
  end

  @num_dump += 1
end

file = open('MSW_sites.txt')
@out_file = File.new('output.txt', 'w')
@out_file.write "county,state,num_dump\n"

@num_dump = 0
@county, @state = ''
@local_county, @local_state = ''


file.each_line do |line|
  chunks = line.chomp.split(/\s{2,}/)
  if (chunks.length == 5 && chunks[0] =~ /\s?\d+/)
    if chunks[4] =~ /\d+/
      @local_county = chunks[2]
      @local_state  = chunks[3]
    else
      @local_county = chunks[3]
      @local_state  = chunks[4]
    end
    write_and_reassign
  elsif (chunks.length == 6 && chunks[0] =~ /\s?\d+/)
    @local_county = chunks[3]
    @local_state  = chunks[4]
    write_and_reassign
  elsif (chunks.length == 4 || chunks.length == 3) && chunks [0] =~ /\s?\d+/
    @local_county = chunks[-2]
    @local_state  = chunks[-1]
    write_and_reassign
  else
    # Garbage
  end
end

file.close
@out_file.close

