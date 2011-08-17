def should_record_cred_stats(method, args, &block)
  stats, _ = CredStats.should_execute(method, args, true, &block)
  stats.should be_saved
end