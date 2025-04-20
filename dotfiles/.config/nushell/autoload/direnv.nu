$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt | append ( source nu-hooks/nu-hooks/direnv/config.nu)
)
