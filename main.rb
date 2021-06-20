$N = 16 # number of subnets
$M = 256 # comps limit
$mask_a = '255.'
$mask_b = '255.255.'
$mask_c = '255.255.255.'
$bin = ''

def check (mask, max_knot)
  if (mask == -1) || (max_knot < $M) || ($M == 0) || ($N == 0) || ($N == 1)
    puts('Impossible to divide to subnets')
    exit(0)
  end
end

def get_range
  (2..$M + 2).each do |i|
    return 2 ** i if 2 ** i > $M + 2
  end
end

def class_a
  puts "Class mask: #{$mask_a}0.0.0"
  bin = 0
  bin_str = ""
  mask = ''
  max_knot = 0
  (0..23).each do |i|
    next unless $N <= 2 ** i

    (0..23).each do |j|
      if $N < 2 ** j
        bin += 1
        bin_str += "0"

        break if bin == 12

        next
      end

      # puts $bin
      bin += 1
      bin_str += "1"

    end
    secnd_oct = bin_str[0,8].to_i(2).to_s
    third_oct = bin_str[8,bin_str.length]

    while third_oct.length != 8
      third_oct += "0"
      if third_oct.length == 8
        tmp = ""
        (0..7).each do |index|
          tmp += third_oct[index]
        end
        third_oct = tmp.to_i(2).to_s
        break
      end
    end

    mask += secnd_oct + "." + third_oct
    #mask = bin.to_i(2).to_s
    max_knot = 2 ** (24 - i) - 2
    break
  end

  check(mask, max_knot)

  print "Mask for subnetting: #{$mask_a}#{mask}"
  puts $mask_a.length <= 10 ? '.0' : ''
  prelast_byte = 0
  last_byte = 0
  min_range = get_range
  second_byte = 0

  (1..$N).each do |i|
    print "Subnet #{i}: 1.#{second_byte}.#{prelast_byte}.#{last_byte}"
    last_byte += min_range

    if last_byte <= 256
      print " - 1.#{second_byte}.#{prelast_byte}."
      if last_byte - 1 > 0
        puts "#{last_byte - 1}"
      else
        puts "#{last_byte - 1 + min_range }"
      end
    elsif last_byte > 256
      prelast_byte += 1
      if prelast_byte == 256
        second_byte += 1
        prelast_byte -= 256
      end
      puts " - 1.#{second_byte}.#{prelast_byte}.#{last_byte >= 256 ? last_byte - 256 : last_byte }"
      last_byte -= 256
    end
  end

end

def class_b
  bin = 0
  bin_str = ""
  mask = ""
  max_knot = 0
  puts("Class mask: #{$mask_b}0.0")

  (0..15).each do |i|
    next unless $N <= 2 ** i

    (0..15).each do |j|
      if $N < 2 ** j
        bin += 1
        bin_str += "0"


        break if bin == 12

        next
      end
      bin += 1
      bin_str += "1"
    end
    secnd_oct = bin_str[0,8].to_i(2).to_s
    third_oct = bin_str[8,bin_str.length]
    while third_oct.length != 8
      third_oct += "0"
      if third_oct.length == 8
        tmp = ""
        (0..7).each do |index|
          tmp += third_oct[index]
        end
        third_oct = tmp.to_i(2).to_s
        break
      end
    end

    mask += secnd_oct + "." + third_oct

    max_knot = 2 ** (16 - i) - 2
    break
  end

  check(mask, max_knot)

  print "Mask for subnetting: #{$mask_b}#{mask}"

  puts mask.length == 0 ? '.0' : ''
  puts ''
  prelast_byte = 0
  last_byte = 0
  min_range = get_range

  (1..$N).each do |i|
    print "Subnet #{i}: 140.255.#{prelast_byte}.#{last_byte}"
    last_byte += min_range

    if last_byte < 256
      print " - 140.255.#{prelast_byte}."
      if last_byte - 1 > 0
        puts "#{last_byte - 1}"
      else
        puts "#{last_byte - 1 + min_range }"
      end

    elsif last_byte >= 256
      last_byte += min_range
      prelast_byte += 1
      puts " - 140.255.#{prelast_byte}.#{last_byte >= 256 ? last_byte - 256 : last_byte }"
      last_byte -= 256
    end
  end
end

def class_c
  mask = ''
  max_knot = 0
  bin = 0
  bin_str = ""
  puts("Class mask: #{$mask_c}0")

  (0..7).each do |i|
    next unless $N <= 2 ** i

    (0..7).each do |j|
      if $N < 2 ** j
        bin += 1
        bin_str += "0"

        break if bin == 8

        next
      end
      bin += 1
      bin_str += "1"
    end

    mask = bin_str[0,8].to_i(2).to_s
    max_knot = 2 ** (8 - i) - 2
    break
  end

  check(mask, max_knot)

  puts "Mask for subnetting: #{$mask_c}#{mask}"

  last_byte = 0
  min_range = get_range

  (1..$N).each do |i|
    print "Subnet #{i}: 255.255.255.#{last_byte}"
    last_byte += min_range

    if last_byte <= 256
      print " - 255.255.255."
      if last_byte - 1 > 0
        puts "#{last_byte - 1}"
      else
        puts "#{last_byte - 1 + min_range }"
      end
    end
  end
end

puts '*******************************************************'
puts "Class: A\n Number of subnets: #{$N}\n Computers limit in subnet: #{$M}"
puts '*******************************************************'
class_a

puts '*******************************************************'
puts "Class: B\n Number of subnets: #{$N}\n Computers limit in subnet: #{$M}"
puts '*******************************************************'

class_b

puts '*******************************************************'
puts "Class: C\n Number of subnets: #{$N}\n Computers limit in subnet: #{$M}"
puts '*******************************************************'

class_c

