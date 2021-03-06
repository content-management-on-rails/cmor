module <%= controller_class.deconstantize %>
  class <%= controller_class.demodulize %> < <%= current_engine.chomp('::Engine') %>::Configuration.base_controller.constantize
    include Rao::ServiceController::RestActionsConcern
    include Rao::ServiceController::ServiceConcern
    include Rao::ServiceController::RestServiceUrlsConcern
    include Rao::ServiceController::ServiceInflectionsConcern

    def self.service_class
      <%= service_class %>
    end

    private

    def permitted_params
      params.require(:<%= params_name %>).permit()
    end
  end
end