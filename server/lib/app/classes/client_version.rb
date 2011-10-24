# Class for things that relate to client version.
class ClientVersion
  # 00000000001111
  # 01234567890123 <-- character indexes
  # yyyy-mmdd-hhmm
  VERSION_RE = /^\d{4}-[01]\d[0-3]\d-[012]\d[0-5]\d$/
  VERSION_STR = "%Y-%m%d-%H%M"
  DEV_VERSION = 'dev'

  # Check if client version is recent enough.
  def self.ok?(version)
    return true if version == DEV_VERSION
    version = parse(version)
    return false if version.nil?
    required = parse(Cfg.required_client_version)
    version >= required
  end

  # Parse version number into +Time+ object. Return nil if it fails.
  def self.parse(version)
    if version.match(VERSION_RE)
      DateTime.strptime(version, VERSION_STR).to_time
    else
      nil
    end
  end
end