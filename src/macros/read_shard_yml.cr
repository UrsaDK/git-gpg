require "yaml"

def shard
  shard_yml = "#{__DIR__}/../../shard.yml"
  YAML.parse(File.read(shard_yml))
end

def shard_tuple
  {
    name: shard["name"].as_s.strip,
    authors: Tuple(String).from(shard["authors"].as_a.map { |i| i.as_s.strip }),
    version: shard["version"].as_s.strip,
    description: shard["description"].as_s.strip,
    repository: shard["repository"].as_s.strip,
    license: shard["license"].as_s.strip,
  }
end

shard_tuple.each do |key, value|
  puts <<-END_OF_METHOD
  def #{key}
    #{value}
  end
  END_OF_METHOD
end
