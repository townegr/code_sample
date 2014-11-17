def fedex_credentials
  @fedex_credentials ||= credentials["development"]["fedex"]
end

def fedex_production_credentials
  @fedex_production_credentials ||= credentials["production"]["fedex"]
end

private

def credentials
  @credentials ||= begin
    YAML.load_file("#{File.dirname(__FILE__)}/../../config/secrets.yml")
  end
end
