shared_examples_for "with param options" do |required_params|
  options = required_params.is_a?(Array) \
    ? {:required => required_params} \
    : required_params
  options.assert_valid_keys(
    :required, :only_push, :needs_login, :needs_control_token
  )
  options.reverse_merge!(
    :required => [], :only_push => false, :needs_login => true,
    :needs_control_token => false
  )

  options[:required].each do |param|
    it "should require #{param} parameter" do
      message = create_message(
        @action, @params.except(param.to_s), options[:only_push],
        options[:needs_login]
      )
      lambda do
        check_options!(message)
      end.should raise_error(GenericController::ParamOpts::BadParams)
    end
  end

  if options[:only_push]
    it "should fail when invoked" do
      message = create_message(@action, @params, false, options[:needs_login])
      lambda do
        check_options!(message)
      end.should raise_error(GenericController::ParamOpts::BadParams)
    end

    it "should not fail when pushed" do
      message = create_message(@action, @params, true, options[:needs_login])
      check_options!(message)
    end
  else
    it "should not fail when invoked" do
      message = create_message(@action, @params, false, options[:needs_login])
      check_options!(message)
    end

    it "should not fail when pushed" do
      message = create_message(@action, @params, true, options[:needs_login])
      check_options!(message)
    end
  end

  if options[:needs_login]
    it "should not fail when with player" do
      message = create_message @action, @params, options[:only_push], true
      check_options!(message)
    end

    it "should fail when without player" do
      pushed = @method == :push
      message = create_message @action, @params, options[:only_push], false
      lambda do
        check_options!(message)
      end.should raise_error(GenericController::ParamOpts::BadParams)
    end
  else
    it "should not fail when with player" do
      # Cannot use #player because it might be defined in the test.
      login if @player.nil?
      message = create_message @action, @params, options[:only_push], true
      check_options!(message)
    end

    it "should not fail when without player" do
      message = create_message @action, @params, options[:only_push], false
      check_options!(message)
    end
  end

  if options[:needs_control_token]
    it "should fail without control token" do
      lambda do
        message = create_message(
          @action,
          @params.except(GenericController::ParamOpts::CONTROL_TOKEN_KEY),
          options[:only_push], options[:needs_login]
        )
        check_options!(message)
      end.should raise_error(GenericController::ParamOpts::BadParams)
    end

    it "should fail with bad control token" do
      lambda do
        message = create_message(
          @action,
          @params.merge(
            GenericController::ParamOpts::CONTROL_TOKEN_KEY => "asdfasasdgfdgdf"
          ),
          options[:only_push], options[:needs_login]
        )
        check_options!(message)
      end.should raise_error(GenericController::ParamOpts::BadParams)
    end
  end
end