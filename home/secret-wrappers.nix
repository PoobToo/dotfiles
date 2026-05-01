{ ... }:

# fish function that wraps the api key + MCP servers for GLM via claude code

{
  programs.fish.functions = {
    zcode = {
      description = "Claude Code via GLM endpoint";
      body = ''
        set -l _token (age -d -i $HOME/.config/age/key.txt ${./../secrets/glm.age} 2>/dev/null)
        if test -z "$_token"
            echo "zcode: decryption failed — check ~/.config/age/key.txt" >&2
            return 1
        end
        set -lx ANTHROPIC_AUTH_TOKEN $_token
        set -lx Z_AI_API_KEY $_token
        set -lx ANTHROPIC_BASE_URL "https://api.z.ai/api/anthropic"
        set -lx API_TIMEOUT_MS 3000000
        set -lx ANTHROPIC_DEFAULT_HAIKU_MODEL  glm-4.5-air
        set -lx ANTHROPIC_DEFAULT_SONNET_MODEL glm-5-turbo
        set -lx ANTHROPIC_DEFAULT_OPUS_MODEL   glm-5.1
        command claude --mcp-config ${./programs/zcode/mcp.json} --disallowedTools "WebSearch WebFetch" $argv
      '';
    };
  };
}
