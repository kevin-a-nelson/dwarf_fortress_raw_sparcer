# functions:
#   all_headers
#   header?
#   parse_header
#   display_header
class DFRawHeaderParcer
  # reads all headers
  # inserts super classes in hash as keys
  # inserts sub classes into hash as value to associated super class key
  def all_headers_hash(file)
    all_objects_hash = {}

    file.each do |line|
      next unless header?(line)

      header = parse_header(line)
      sub_class = header[:sub_class]
      super_class = header[:super_class]
      super_class = super_class.to_sym

      if all_objects_hash.key?(super_class)
        all_objects_hash[super_class] << sub_class
      else
        all_objects_hash[super_class] = [sub_class]
      end
    end
    all_objects_hash
  end

  # header format is [super_class:sub_class]
  def header?(line)
    line.match(/^\[\w+:\w+\]/)
  end

  # parses [super_class:sub_class] to
  #
  # {
  #   super_class: 'super_class'
  #   sub_class: 'sub_class'
  # }
  def parse_header(line)
    header = {
      super_class: '',
      sub_class: ''
    }

    super_class = line.match(/\[(\w+)/)[1]
    sub_class = line.match(/(\w+)\]/)[1]

    header[:super_class] = super_class
    header[:sub_class] = sub_class

    header
  end

  # prints { super_object1: ['sub_object1','sub_object2], super_object2: ... } as
  #
  # super_object1
  #   sub_object1
  #   sub_object2
  #
  # super_object2
  #   sub_object1
  #   sub_object2
  def all_headers_str(file)
    all_headers_h = all_headers_hash(file)
    all_headers_s = ''
    all_headers_h.each do |super_class, sub_objects|
      all_headers_s += "#{super_class.to_s}\n"
      sub_objects.each do |sub_class|
        all_headers_s += "\t#{sub_class}\n"
      end
      all_headers_s += "\n"
    end
    all_headers_s
  end
end

file_name = 'creature_other'
path = 'raw/objects/'

file = File.open("#{path}#{file_name}.txt", 'r')

DF_raw_header_parcer = DFRawHeaderParcer.new

puts DF_raw_header_parcer.all_headers_str(file)
puts DF_raw_header_parcer.all_headers_hash(file)