def should_execute_and_save(target, method, args, &block)
  model, _ = target.should_execute(method, args, true, &block)
  model.should be_saved
end