dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', 'lib')
require 'anagram'
require File.join(dir, 'parseq_treetop')
require File.join(dir, 'parseq_treetop_bla')
require File.join(dir, 'parseq_anagram')

class SeqParBenchmark
  
  OPERATORS = ["par", "seq"]
  
  PARSERS = [ByTreetop::Parser, 
             ByTreetopBla::Parser,
             ByAnagram::Parser]
  
  # Checks the grammar
  def check()
    PARSERS.each do |parser|
      parser = parser.new
      puts "Checking parser #{parser}"
      begin 
        parser.parse("Task")
        parser.parse("seq Task end")
        parser.parse("par Task end")
        parser.parse("seq Task Task end")
        parser.parse("par Task Task end")
        parser.parse("par seq Task end Task end")
        parser.parse("par seq seq Task end end Task end")
        parser.parse("seq Task par seq Task end Task end Task end")
      rescue => ex
        puts "Error using #{parser.class}"
        raise ex
      end
    end
  end
  
  # Generates an input text
  def generate(depth=0)
    return "Task" if depth>7
    return "seq #{generate(depth+1)} end" if depth==0
    which = rand(OPERATORS.length)
    case which
      when 0
        "Task"
      else
        raise unless OPERATORS[which]
        buffer = "#{OPERATORS[which]} "
        0.upto(rand(5)+1) do 
          buffer << generate(depth+1) << " "
        end
        buffer << "end"
        buffer
    end
  end
  
  # Launches benchmarking
  def benchmark
    number_by_size = Hash.new {|h,k| h[k] = 0}
    time_by_size   = Hash.new {|h,k| h[k] = PARSERS.collect{|p| 0}}
    
    0.upto(400) do |i|
      input = generate
      length = input.length
      number_by_size[length] += 1

      puts "Lauching #{i}: #{input.length}"
      #puts input
      
      0.upto(PARSERS.size-1) do |p|
        t1 = Time.now
        PARSERS[p].new.parse(input)
        t2 = Time.now
        time_by_size[length][p] += (t2-t1)*1000
      end
    end
    
    File.open(File.join(File.dirname(__FILE__), 'parseq_benchmark.dat'), 'w') do |dat|
      number_by_size.keys.sort.each do |size|
        values = time_by_size[size].collect {|time| (time/number_by_size[size]).truncate}
        dat << "#{size} #{values.join(" ")}\n"
      end
    end
  end
  
end

SeqParBenchmark.new.check
SeqParBenchmark.new.benchmark