module Seahorse
  module Client
    module Logging
      class Handler < Client::Handler

        # @param [RequestContext] context
        # @return [Response]
        def call(context)
          context[:started_at] = Time.now
          @handler.call(context).on_complete do |response|
            context[:completed_at] = Time.now
            log(context.config, response)
          end
        end

        private

        # @param [Configuration] config
        # @param [Response] response
        # @return [void]
        def log(config, response)
          config.logger.send(config.log_level, format(config, response))
        end

        # @param [Configuration] config
        # @param [Response] response
        # @return [String]
        def format(config, response)
          config.log_formatter.format(response)
        end

      end
    end
  end
end
