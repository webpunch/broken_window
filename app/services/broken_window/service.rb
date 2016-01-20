module BrokenWindow
  module Service
    def self.included(base)
      base.extend(ClassMethods)

      # From http://brewhouse.io/blog/2014/04/30/gourmet-service-objects.html
      # Possible responses
      # 1:  Fail loudly
      # 2:  Return ActiveRecord results
      # 3: Response object
      # Some services have several outcomes and complex error handling. They return a response object which responds to success? and error(s).
      def call
        raise NotImplementedError
      end
    end

    module ClassMethods
      def call(*args)
        new(*args).call
      end
    end
  end
end
