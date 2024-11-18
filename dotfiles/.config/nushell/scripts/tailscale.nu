def statuses [] {
    [
        on # Use suggested node
        off # Set exit-node to nothing
        set # Select a node
    ]
}

def exit-nodes [] {
    tailscale exit-node list
    | lines -s
    | drop 4
    | split column -c --regex '\s\s+' ip exit-node country city status
    | skip 2
    | each {|node| {value: $node.exit-node, description: $"($node.country) - ($node.city)"}}
}

# Set tailscale exit node for mullvad vpn.
export def vpn [status: string@statuses, exit_node?: string@exit-nodes] {
    match $status {
        "on" => {
            let suggestion = tailscale exit-node suggest | parse --regex "node: (.*)" | first | get capture0
            tailscale set --exit-node=($suggestion)
            print $"Connected to `($suggestion)`."
        },
        "off" => {
            tailscale set --exit-node=
            print "Disconnected."
        },
        "set" => {
            if $exit_node == null {
                error make {
                    msg: "Did not provide an exit node."
                    label: {
                        text: "should be an exit-node `hostname`"
                        span: (metadata $exit_node).span
                    }
                    help: "Use one of the exit-nodes provided by `tailscale exit-node list`"
                }
            }
            tailscale set --exit-node=($exit_node)
            print $"Connected to `($exit_node)`."
        },
        _ => {
            error make {
                msg: "invalid status of vpn"
                label: {
                    text: "should be `on` or `off`"
                    span: (metadata $status).span
                }
            }
        }
    }
}
