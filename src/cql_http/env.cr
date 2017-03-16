require "yaml"

config = YAML.parse File.read("./config/config.yml")
env = ENV["ENV"]? || "development"
setting = config[env]

ENV["cql_host"] = setting["host"].as_s
ENV["cql_port"] = setting["port"].as_s
ENV["cql_sh"] = setting["cqlsh"].as_s

# timezone setting
ENV["TZ"] = "Asia/Shanghai"
