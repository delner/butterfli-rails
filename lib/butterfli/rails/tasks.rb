module Butterfli::Rails::Tasks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Environment
    def rails_env_loaded?
      @rails_env_loaded ||= false
    end
    def load_rails_env
      if !rails_env_loaded?
        puts "** Loading Rails environment... **"
        Rake::Task["environment"].invoke
        @rails_env_loaded = true
      end
      false
    end

    # Routing
    class Router
      include ActionDispatch::Routing::UrlFor
    end
    def router(engine = nil)
      load_rails_env if !rails_env_loaded?
      engine ||= Rails.application
      new_router = Router.new
      new_router.class_eval do
        include engine.routes.url_helpers
      end
      new_router
    end
    def url_for(host, options = {})
      return host if host.start_with?("http://")
      load_rails_env if !rails_env_loaded?
      url_for_options = {}
      url_for_options[:controller] = controllers[options[:controller]].constantize.controller_path
      url_for_options[:action] = options[:action]
      router(engine).url_for(url_for_options.merge(host: host))
    end
    def controllers
      @controllers ||= {}
    end
    def controller(name, klass)
      controllers[name] = klass
    end
    def engine(klass = nil)
      @engine ||= klass
    end

    # Configuration
    def configure
      load_rails_env if !rails_env_loaded?
      Butterfli.configuration
    end
  end
end