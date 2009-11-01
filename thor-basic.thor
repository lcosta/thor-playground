require 'pp'

class T < Thor
  
  # examples
  #   → thor t:t1 --att2="string 1"
  #   {"att1"=>{}, "att2"=>"string 1"}
  # 
  #   → thor t:t1 --att1=arg1 "argument 2" --att2="string 1"
  #   {"att1"=>["arg1", "argument 2"], "att2"=>"string 1"}
  
  desc "t1", "test 1 - set options"
  method_option :att1, :type => :array, :default => {}, :required => true
  method_option :att2, :type => :string, :required => true
  def t1
    pp options
  end
  
  
  # examples
  #   → thor t:t2
  #   {}
  # 
  #   → thor t:t2 --upcase
  #   {"upcase"=>true}
  # 
  #   → thor t:t2 --no-upcase
  #   {"upcase"=>false}
  # 
  #   → thor t:t2 -u=false
  #   {"upcase"=>false}

  desc "t2", "test 2 - set option with alias"
  method_options %w( upcase -u) => :boolean
  def t2
    pp options
  end
  
  
  # examples
  #   → thor t:t3 first_arg
  #   {}
  #   "first_arg"
  #   ""
  
  desc "t3", "teste3 - set parameters"
  def t3(arg1, arg2="")
    pp options
    pp arg1
    pp arg2
  end
  
  
  # examples
  #   → thor t:t4
  #   {"verbose"=>true}
  #   true
  # 
  #   → thor t:t4 --force
  #   {"force"=>true, "verbose"=>true}
  #   true
  # 
  #   → thor t:t4 false --force
  #   {"force"=>true, "verbose"=>true}
  #   "false"
  
  desc "t4", "teste4 - set options inline"
  method_options :force => false, :verbose => true
  def t4(arg1=true)
    pp options
    pp arg1
  end
  
  
end


# namespace example 
module St
  class T < Thor
    
    # example
    #   → thor st:t:t1 value1
    #   {}
    #   "value1"
    
    desc "t1", "test 1 - invoked as namespace"
    def t1(arg1)
      pp options
      pp arg1
    end
  end
end


class Counter < Thor
  
  # example
  #   → thor counter:one
  #   1
  #   2
  #   3
  # 
  # => The output is "1 2 3", which means that the three task was invoked only once. You can even 
  # invoke tasks from another class, so be sure to check the documentation.
  
  desc "one", "Prints 1, 2, 3"
  def one
    puts 1
    invoke :two
    invoke :three
  end

  desc "two", "Prints 2, 3"
  def two
    puts 2
    invoke :three
  end

  desc "three", "Prints 3"
  def three
    puts 3
  end
end


class Task < Thor::Group
  
  # example
  #   → thor task
  #   1
  #   2
  #   3
  # 
  # => It prints "1 2 3" as well. Notice you should describe (using the method desc) only the class 
  # and not each task anymore. Thor::Group is a great tool to create generators, since you can define 
  # several steps which are invoked in the order they are defined (Thor::Group is the tool use in 
  # generators in Rails 3.0).

  desc "Prints 1, 2, 3"

  def one
    puts 1
  end

  def two
    puts 2
  end

  def three
    puts 3
  end
end


class Counter2 < Thor::Group
  
  # example
  #   → thor counter2 1000
  #   1000
  #   1001
  #   1002
  #
  # => Besides, Thor::Group can parse arguments and options as Thor tasks.
  #
  # => You can also give options to Thor::Group, but instead of using method_option and 
  # method_options, you should use class_option and class_options. Both argument and class_options 
  # methods are available to Thor class as well.
  #
  # number will be available as attr_accessor
  
  argument :number, :type => :numeric, :desc => "The number to start counting"
  desc "Prints the 'number' given upto 'number+2'"

  def one
    puts number + 0
  end

  def two
    puts number + 1
  end

  def three
    puts number + 2
  end
end


class Actions < Thor
  include Thor::Actions # online help (http://rdoc.info/projects/wycats/thor)
  
  desc "examples", "examples use the actions"
  def examples
    
    create_file "/tmp/lcosta-thor_examples/actions/fun_party.rb" do
      hostname = ask("What is the virtual hostname I should use?")
      "vhost.name = #{hostname}\n#{Time.now}"
    end
    
    create_file "/tmp/lcosta-thor_examples/actions/apach.conf", "your apache config\n#{Time.now}"
    
    puts "\n\nOutput:\n-----------\n"
    run "cat /tmp/lcosta-thor_examples/actions/fun_party.rb", :verbose => true
    puts
    run "cat /tmp/lcosta-thor_examples/actions/apach.conf", :verbose => true
    
    # TODO: ver como chamar tarefas thor, como -  thor t:t1 --att1=arg1 "argument 2" --att2="string 1"
    # thor :t[:t1], :att1 => ["arg1", "argument 2"],  :att2 => "string 1"

  end
  
  # include Thor::Shell::Basic
  desc "thor_shell_basic", "# Thor::Shell::Basic (class)"
  def thor_shell_basic
    say("I know you knew that.")
    puts "\n-----------\n\n"
    print_table [
                  ["head1", "head2", "head3", "head4"],
                  ["-----", "-----", "-----", "-----"],
                  ["data1", "data2", "data3", "data4"],
                  ["data1", "data2, BIG DATA!!!", "data3", "data4"],
                  ["data1", "data2", "data3", "data4"]
                ],
                :ident => 0
    print_table [
                  ["head1", "head2", "head3", "head4"],
                  ["-----", "-----", "-----", "-----"],
                  ["data1", "data2", "data3", "data4"],
                  ["data1", "data2, BIG DATA!!!", "data3", "data4"],
                  ["data1", "data2", "data3", "data4"]
                ],
                :ident => 10
  end
end
