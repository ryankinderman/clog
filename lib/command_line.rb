class CommandLine
  class CommandLineParameters < Hash
    def method_missing(method_sym, *args)
      if self.include?(method_sym)
        return self[method_sym]
      end
      super
    end
  end
  
  class << self
  
    def parse(args, error='')
      validate(args)
    
      hash = {
        :command => args[0],
        :host => args[1],
        :xmlrpc_path => args[2],
        :login => args[3],
        :password => args[4],
        :post_path => args[5]
      }
      cmdline_params = CommandLineParameters.new
      yield cmdline_params.merge(hash)
    end
    
    def syntax
      syntax_str =<<-eos
Syntax: blogctl dump host xmlrpc_path login password post_path
dump            command to dump all blog entries from a blog to a specified 
                local directory
host            the blog host address (ex: myblog.com)
xmlrpc_path     the path to your blog's XMLRPC service (currently only 
                metaWeblog)
login           the login to your blog
password        the password to your blog
post_path       the path on your local computer that you want to write the blog 
                posts to
      eos
    end
  
    private
  
    def validate(args)
      raise StandardError, "Too few arguments" if args.size < 6
      raise StandardError, "Too many arguments" if args.size > 6
    end
  
  end
end