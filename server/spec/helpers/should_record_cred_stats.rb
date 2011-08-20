def should_record_cred_stats(method, args, &block)
  should_execute_and_save(CredStats, method, args, &block)
end