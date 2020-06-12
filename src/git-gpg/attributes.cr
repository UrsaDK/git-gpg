module GitGPG
  module Attributes
    extend self

    {{ run("#{__DIR__}/../macros/read_shard_yml") }}
  end
end
