module RailsAmp
  class Railtie < Rails::Railtie
    initializer 'rails_amp' do |app|
      ActiveSupport.on_load :action_controller do
        include RailsAmp::Initializer
      end
    end
  end

  module Initializer
    extend ActiveSupport::Concern

    included do
      before_action do
        RailsAmp.format = request[:format]
        if request[:format] == RailsAmp.amp_format.to_s  # default amp_format is :amp
          override_actions_with_rails_amp
        end
      end
    end

    private

      def override_actions_with_rails_amp
        return if defined?(@@override_actions_with_rails_amp) && @@override_actions_with_rails_amp
        klass = self.class
        actions = RailsAmp.target_actions(klass)
        klass.class_eval do
          prepend(Module.new {
            actions.to_a.each do |action|
              define_method action.to_sym do
                super()
                respond_to do |format|
                  format.amp do
                    # search .amp .html templates
                    lookup_context.formats = [:amp, :html]
                    render layout: false
                  end
                end
              end
            end
          })
          @@override_actions_with_rails_amp = true
        end
      end
  end
end
